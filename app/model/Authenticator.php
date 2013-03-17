<?php

use Nette\Security,
    Nette\Utils\Strings;

/**
 * Class Authenticator
 * Authenticator is used for loging in, logout, changing password,
 * working with $SESSION etc.
 */
class Authenticator extends Nette\Object implements Security\IAuthenticator {

    /** @var Nette\Database\Connection */
    private $database;

    public function __construct(Nette\Database\Connection $database) {
        $this->database = $database;
    }

    /**
     * Performs an authentication.
     * @return Nette\Security\Identity
     * @throws Nette\Security\AuthenticationException
     */
    public function authenticate(array $credentials) {
        list($username, $password) = $credentials;
        $row = $this->database->table('users')->where('username', $username)->fetch();

        if (!$row) {
            throw new Security\AuthenticationException('The username is incorrect.', self::IDENTITY_NOT_FOUND);
        }

        if ($row->password !== $this->calculateHash($password, $row->password)) {
            throw new Security\AuthenticationException('The password is incorrect.', self::INVALID_CREDENTIAL);
        }

        unset($row->password);
        return new Security\Identity($row->id, $row->role, $row->toArray());
    }

    /**
     * Computes salted password hash.
     * @param  string
     * @return string
     */
    public static function calculateHash($password, $salt = NULL) {
        if ($password === Strings::upper($password)) { // perhaps caps lock is on
            $password = Strings::lower($password);
        }
        return crypt($password, $salt ? : '$2a$07$' . Strings::random(22));
    }
          
    protected function getTable($table)
    {
        
        return $this->database->table($table);
    }
}
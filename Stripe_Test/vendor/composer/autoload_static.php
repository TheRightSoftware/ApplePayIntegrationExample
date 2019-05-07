<?php

// autoload_static.php @generated by Composer

namespace Composer\Autoload;

class ComposerStaticInitf15c47d9a5cf2a45cccd5d3fe42dfee0
{
    public static $prefixLengthsPsr4 = array (
        'S' => 
        array (
            'Stripe\\' => 7,
        ),
    );

    public static $prefixDirsPsr4 = array (
        'Stripe\\' => 
        array (
            0 => __DIR__ . '/..' . '/stripe/stripe-php/lib',
        ),
    );

    public static function getInitializer(ClassLoader $loader)
    {
        return \Closure::bind(function () use ($loader) {
            $loader->prefixLengthsPsr4 = ComposerStaticInitf15c47d9a5cf2a45cccd5d3fe42dfee0::$prefixLengthsPsr4;
            $loader->prefixDirsPsr4 = ComposerStaticInitf15c47d9a5cf2a45cccd5d3fe42dfee0::$prefixDirsPsr4;

        }, null, ClassLoader::class);
    }
}

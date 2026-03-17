use BotMan\BotMan\BotMan;
use BotMan\BotMan\BotManFactory;
use BotMan\BotMan\Drivers\DriverManager;

$config = [];
DriverManager::loadDriver(\BotMan\Drivers\Web\WebDriver::class);

$botman = BotManFactory::create($config);

$botman->hears('hola', function (BotMan $bot) {
    $bot->reply('¡Hola! Soy tu asistente Musilux.');
});

$botman->listen();

<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('productos', function (Blueprint $table) {
    $table->uuid('id')->primary(); // Usamos UUID como ID primario
    
    // Relación con categorías
    $table->foreignId('categoria_id')->constrained('categorias')->onDelete('cascade');
    
    $table->string('nombre');
    $table->string('slug')->unique();
    $table->text('descripcion')->nullable();
    $table->string('tipo_producto'); // fisico, digital, servicio
    $table->decimal('precio', 10, 2);
    $table->integer('inventario');
    $table->integer('bpm')->nullable();
    $table->boolean('esta_activo')->default(true);
    $table->timestamps();
});

    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('productos');
    }
};

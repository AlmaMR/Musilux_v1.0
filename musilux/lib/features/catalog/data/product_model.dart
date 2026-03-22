class ProductModel {
  final String? id;
  final String nombre;
  final String slug;
  final String? descripcion;
  final String tipoProducto;
  final double precio;
  final int inventario;
  final int? bpm;
  final bool estaActivo;
  // Campos de integración Spotify
  final String? spotifyTrackId;
  final String? spotifyTrackName;
  final String? spotifyArtistName;
  final String? spotifyPreviewUrl;
  final String? spotifyAlbumImageUrl;

  ProductModel({
    this.id,
    required this.nombre,
    required this.slug,
    this.descripcion,
    required this.tipoProducto,
    required this.precio,
    required this.inventario,
    this.bpm,
    this.estaActivo = true,
    this.spotifyTrackId,
    this.spotifyTrackName,
    this.spotifyArtistName,
    this.spotifyPreviewUrl,
    this.spotifyAlbumImageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString(),
      nombre: json['nombre'] ?? '',
      slug: json['slug'] ?? '',
      descripcion: json['descripcion'],
      tipoProducto: json['tipo_producto'] ?? 'fisico',
      precio: double.tryParse(json['precio'].toString()) ?? 0.0,
      inventario: int.tryParse(json['inventario'].toString()) ?? 0,
      bpm: json['bpm'] != null ? int.tryParse(json['bpm'].toString()) : null,
      estaActivo: json['esta_activo'] == 1 || json['esta_activo'] == true,
      spotifyTrackId: json['spotify_track_id']?.toString(),
      spotifyTrackName: json['spotify_track_name']?.toString(),
      spotifyArtistName: json['spotify_artist_name']?.toString(),
      spotifyPreviewUrl: json['spotify_preview_url']?.toString(),
      spotifyAlbumImageUrl: json['spotify_album_image_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'slug': slug,
      'descripcion': descripcion,
      'tipo_producto': tipoProducto,
      'precio': precio,
      'inventario': inventario,
      'bpm': bpm,
      'esta_activo': estaActivo,
      'spotify_track_id': spotifyTrackId,
      'spotify_track_name': spotifyTrackName,
      'spotify_artist_name': spotifyArtistName,
      'spotify_preview_url': spotifyPreviewUrl,
      'spotify_album_image_url': spotifyAlbumImageUrl,
    };
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/app_router.dart';
import '../../theme/colors.dart';

class SuperAdminDashboard extends StatelessWidget {
  const SuperAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.headerBg,
      appBar: AppBar(
        title: Text('Super Admin — ${auth.usuario?.nombres ?? ''}'),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.login,
                  (_) => false,
                );
              }
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _DashboardCard(
            icon: Icons.inventory_2_outlined,
            label: 'Inventario',
            color: Colors.indigo,
            onTap: () => Navigator.pushNamed(context, AppRoutes.inventarioDashboard),
          ),
          _DashboardCard(
            icon: Icons.receipt_long_outlined,
            label: 'Pedidos',
            color: Colors.orange,
            onTap: () => Navigator.pushNamed(context, AppRoutes.pedidosDashboard),
          ),
          _DashboardCard(
            icon: Icons.people_outlined,
            label: 'Usuarios',
            color: Colors.teal,
            onTap: () => Navigator.pushNamed(context, AppRoutes.usuariosDashboard),
          ),
          _DashboardCard(
            icon: Icons.bar_chart_outlined,
            label: 'Ventas',
            color: Colors.green,
            onTap: () => Navigator.pushNamed(context, AppRoutes.ventasDashboard),
          ),
          _DashboardCard(
            icon: Icons.support_agent_outlined,
            label: 'Soporte',
            color: Colors.blue,
            onTap: () => Navigator.pushNamed(context, AppRoutes.soporteDashboard),
          ),
          _DashboardCard(
            icon: Icons.admin_panel_settings_outlined,
            label: 'Panel Productos',
            color: Colors.deepPurple,
            onTap: () => Navigator.pushNamed(context, AppRoutes.adminProducts),
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              radius: 32,
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: color,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

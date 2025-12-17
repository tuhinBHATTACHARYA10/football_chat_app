import 'package:flutter/material.dart';
import 'league_select_screen.dart'; // <--- IMPORTANT: Import the new League Screen

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedTeam = 'Home'; // Default selection

  void _joinMatch() {
    if (_nameController.text.isNotEmpty) {
      // 1. Determine color based on team selection
      Color teamColor = _selectedTeam == 'Home' ? Colors.red : Colors.blue;

      // 2. Navigate to the LEAGUE SELECTOR first
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LeagueSelectScreen(
            userName: _nameController.text,
            teamColor: teamColor,
          ),
        ),
      );
    } else {
      // Show a small error if name is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a nickname!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50], // Light grass color background
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(20),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App Logo / Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.sports_soccer, size: 60, color: Colors.green),
                  ),
                  const SizedBox(height: 20),
                  
                  const Text(
                    "Fan Zone Login",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Pick a name and side to start chatting",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  
                  // Name Input
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Your Nickname",
                      hintText: "e.g., Messi10",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.person),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 20),
          
                  // Team Selection Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedTeam,
                    decoration: InputDecoration(
                      labelText: "Preferred Side",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      prefixIcon: Icon(Icons.flag, 
                        color: _selectedTeam == 'Home' ? Colors.red : Colors.blue
                      ),
                    ),
                    items: ['Home', 'Away'].map((String team) {
                      return DropdownMenuItem(
                        value: team,
                        child: Text(
                          team == 'Home' ? 'Home Team (Red)' : 'Away Team (Blue)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: team == 'Home' ? Colors.red : Colors.blue
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedTeam = val!),
                  ),
                  const SizedBox(height: 30),
          
                  // Join Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _joinMatch,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        "ENTER STADIUM", 
                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
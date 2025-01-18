import pyvista as pv
import streamlit as st
from stpyvista import stpyvista

st.title("3D Model Visualization")

# Initialize a PyVista plotter object
plotter = pv.Plotter(window_size=[800, 600])

# Create a sample mesh (e.g., a cube)
mesh = pv.Cube()

# Add the mesh to the plotter
plotter.add_mesh(mesh, color='lightblue')

# Display the plotter in Streamlit
stpyvista(plotter, key="pv_cube")
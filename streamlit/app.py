import pyvista as pv
import streamlit as st
from stpyvista import stpyvista
import plotly.graph_objects as go


def create_mesh():
    st.title("Streamlit Plotly 3D Example")

    # Create a 3D mesh (e.g., a cube)
    fig = go.Figure(data=[go.Mesh3d(
        x=[0, 1, 1, 0, 0, 1, 1, 0],
        y=[0, 0, 1, 1, 0, 0, 1, 1],
        z=[0, 0, 0, 0, 1, 1, 1, 1],
        i=[0, 0, 0, 1, 1, 2, 2, 3, 4, 5, 6, 7],
        j=[1, 2, 3, 2, 3, 3, 6, 7, 5, 6, 7, 4],
        k=[2, 3, 0, 3, 0, 6, 7, 4, 6, 7, 4, 5],
        color='lightblue',
        opacity=0.50
    )])

    st.plotly_chart(fig)

def plot_cube():
    st.title("3D Model Visualization")

    # Initialize a PyVista plotter object
    plotter = pv.Plotter(window_size=[800, 600])

    # Create a sample mesh (e.g., a cube)
    mesh = pv.Cube()

    # Add the mesh to the plotter
    plotter.add_mesh(mesh, color='lightblue')

    # Display the plotter in Streamlit
    stpyvista(plotter, key="pv_cube")


if __name__ == "__main__":
    pv.start_xvfb()
    create_mesh()
    
   
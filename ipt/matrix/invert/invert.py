#!/usr/bin/python

import sys;
import gauss;
import matrix;
import latex;

if __name__ == "__main__":
    # Reading the matrix
    if len(sys.argv) != 2:
        print("Invalid number of arguments : expected 1.")
        exit()
    mat, b = matrix.read(sys.argv[1])
    if not b:
        print("Invalid file :", sys.argv[1])
        exit()
    if len(mat) != len(mat[0]):
        print("Invalid matrix size : expected a square one.")
        exit()
    matrix.output(mat)
    print("Inverting ...")

    # LaTeX output
    latex.begin("latex.matrix")
    latex.beq()
    latex.matrix(mat)
    latex.output("\\\\")

    # Adding identity
    size = len(mat)
    for i in range(len(mat)):
        add = [0] * len(mat)
        add[i] = 1
        mat[i] += add

    # Triangularize
    comp = gauss.triangularize(mat, size)
    if len(comp) != 0:
        print("Can't invert the matrix.")
        latex.enq()
        latex.output("Can't invert the matrix.\n")
        latex.end("Inverting the matrix")
        exit()

    # Eliminating
    for i in range(len(mat)):
        matrix.mult(mat, i, 1/mat[i][i])
        for j in range(i):
            matrix.add(mat, j, -mat[j][i]/mat[i][i], i)
        latex.output("\\\\\\Rightarrow")
        latex.matrix(mat)

    # Output
    invert = []
    for i in range(len(mat)):
        invert += [[0] * size]
        for j in range(size):
            invert[i][j] = mat[i][j + size]
    matrix.output(invert)

    # LaTeX output
    latex.enq()
    latex.output("\\\\Inverse :\n")
    latex.beq()
    latex.matrix(invert)
    latex.enq()
    latex.end("Inversing a matrix")


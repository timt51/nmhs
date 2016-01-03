function frmpc = fmpcWrapper(tr1, tr2, e1, e2, seq1, seq2, pStates1, pStates2)
  frmpc = friedmanmpc(pStates1, seq1, e1);

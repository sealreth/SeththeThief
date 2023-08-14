return {
  name = "TiledGame",
  description = "Tiled based Engine",
  api = {"baselib", "tiledgame"},
	
  frun = function(self,wfilename,rundebug)
     return CommandLineRun("TiledGame.exe",self:fworkdir(wfilename),true,true, nil, nil )
  end,
	
	fprojdir = function(self,wfilename)
    return wfilename:GetPath(wx.wxPATH_GET_VOLUME)
  end,
	
  fworkdir = function(self,wfilename)
    return ide.config.path.projectdir or wfilename:GetPath(wx.wxPATH_GET_VOLUME)
  end,
	
  hasdebugger = true,
  fattachdebug = function(self) DebuggerAttachDefault() end,
  scratchextloop = true,
  takeparameters = true,
}

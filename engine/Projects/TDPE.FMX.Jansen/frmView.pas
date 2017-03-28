(*
 * Copyright (c) 2010-2017 Thundax Delphi Physics Engine
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 * * Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 *
 * * Neither the name of 'TDPE' nor the names of its contributors
 *   may be used to endorse or promote products derived from this software
 *   without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *)

unit frmView;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, tdpe.lib.engine,
  tdpe.lib.vector, tdpe.lib.render.fmx,
  tdpe.lib.jansen.scenery, tdpe.lib.engine.wrapper,
  tdpe.lib.particle.group, tdpe.lib.particle.pattern.composite,
  tdpe.lib.particle.circle, tdpe.lib.particle.spring.restriction,
  tdpe.lib.jansen.mechanism, tdpe.lib.jansen.robot, tdpe.lib.particle.box,
  FMX.Layouts, System.UIConsts, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Objects;

type
  TmainView = class(TForm)
    Panel1: TPanel;
    Toggle: TButton;
    Direction: TButton;
    Image1: TImage;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure DirectionClick(Sender: TObject);
    procedure ToggleClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    Engine: TFluentEngine;
    Render: TFMXRenderer;
    FGround: TScenery;
    FRobot: TRobot;
    FBitmap : TBitmap;
  end;

var
  mainView: TmainView;

const
  FullHeight = 623;
  FullWidth = 1252;

implementation

uses
  tdpe.lib.force;

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

procedure TmainView.DirectionClick(Sender: TObject);
begin
  Frobot.toggleDirection();
end;

procedure TmainView.FormCreate(Sender: TObject);
var
  xFactor : double;
  yFactor : double;
begin
  Engine := TFluentEngine.New(1 / 4).AddInitialForce(TForce.Create(false, 0, 2)).AddDamping(0).AddRestrictionCollitionCycles(10);
  FBitmap := TBitmap.Create(Round(image1.Width), Round(image1.Height));
  Render := TFMXRenderer.Create(FBitmap);

  //Calculate x,y factor according to the new height and width
  xFactor := Image1.Width / FullWidth;
  yFactor := Image1.Height / FullHeight;

  FGround := TScenery.Create(Render, Engine, clablue, xFactor, yFactor);
  Frobot := TRobot.Create(Render, Engine, 1050, 400, 1, 0.02, xFactor, yFactor);
  Engine.AddGroups(FGround).AddGroups(Frobot);
  FGround.AddCollidable(Frobot);
  Frobot.togglePower();
end;

procedure TmainView.Timer1Timer(Sender: TObject);
var
  bitmap : TBitmap;
begin
  Engine.Run;
  Frobot.Run();

  bitmap := TBitmap.Create;
  try
    bitmap.SetSize(round(Image1.Width), round(Image1.Height));
    Image1.MultiResBitmap.Bitmaps[1].Assign(bitmap);
    Image1.Bitmap := Image1.MultiResBitmap.Bitmaps[1];
    Image1.Bitmap.Clear(TAlphaColorRec.White);

    Fbitmap.Canvas.BeginScene;
    Fbitmap.Clear(TAlphaColorRec.White);
    Engine.Paint;
    Fbitmap.Canvas.EndScene;
    image1.MultiResBitmap.Bitmaps[1].Assign(Fbitmap);
    image1.Bitmap := image1.MultiResBitmap.Bitmaps[1];
  finally
    bitmap.Free;
  end;
  Application.ProcessMessages;


//    TThread.CreateAnonymousThread(procedure
//    begin
//          Engine.Run();
//          Frobot.Run();
//        TThread.Synchronize(TThread.CurrentThread, procedure
//        begin
//          bitmap := TBitmap.Create;
//          try
//            bitmap.SetSize(round(Image1.Width), round(Image1.Height));
//
//            Image1.MultiResBitmap.Bitmaps[1].Assign(bitmap);
//            Image1.Bitmap := Image1.MultiResBitmap.Bitmaps[1];
//            Image1.Bitmap.Clear(TAlphaColorRec.White);
//
//
//
//            Fbitmap.Canvas.BeginScene;
//            try
//              Image1.Bitmap.Clear(TAlphaColorRec.White);
//
//              Engine.Paint;
//
//            finally
//              Fbitmap.Canvas.EndScene;
//            end;
//            image1.MultiResBitmap.Bitmaps[1].Assign(Fbitmap);
//            image1.Bitmap := image1.MultiResBitmap.Bitmaps[1];
//
//          finally
//            bitmap.Free;
//          end;
//        end);
//    end).Start;





//  bitmap := TBitmap.Create;
//  try
//    bitmap.SetSize(round(Image1.Width), round(Image1.Height));
//    Image1.MultiResBitmap.Bitmaps[1].Assign(bitmap);
//    Image1.Bitmap := Image1.MultiResBitmap.Bitmaps[1];
//    Image1.Bitmap.Clear(TAlphaColorRec.White);
////    TThread.CreateAnonymousThread(procedure
////    begin
////        TThread.Synchronize(nil, procedure
////        begin
////          Engine.Paint;
////        end);
////
////    end).Start;
//
//    Fbitmap.Canvas.BeginScene;
//    try
//      Image1.Bitmap.Clear(TAlphaColorRec.White);
//      Engine.Paint;
//
////     CanvasThread := TThread.CreateAnonymousThread(procedure ()
////     begin
////      TThread.Synchronize(TThread.CurrentThread, procedure
////        begin
////            Fbitmap.Clear(TAlphaColorRec.White);
////            Engine.Paint;
////        end);
////      end);
////      CanvasThread.FreeOnTerminate := true;
////      CanvasThread.Start;
//    finally
//      Fbitmap.Canvas.EndScene;
//    end;
//    image1.MultiResBitmap.Bitmaps[1].Assign(Fbitmap);
//    image1.Bitmap := image1.MultiResBitmap.Bitmaps[1];
//  finally
//    bitmap.Free;
//  end;
end;

procedure TmainView.ToggleClick(Sender: TObject);
begin
  Timer1.Enabled := not Timer1.Enabled;
  Frobot.togglePower();
end;

end.

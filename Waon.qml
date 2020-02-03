//=============================================================================
//  MuseScore プラグイン
//  コードの一番上の音以外をベロシティ -25 にする
//
//  Copyright (C) 2020 sharapeco@github
//
//  This program is distributed under the MIT license
//=============================================================================

import QtQuick 2.0
import MuseScore 3.0

MuseScore {
	version: "1.0"
	description: "コードの一番上の音以外をベロシティ -25 にします"
	menuPath: "Plugins.Waon!"

	function eachNotes(fn) {
		if (!curScore) return;

		var cursor = curScore.newCursor();
		for (var staff = 0; staff < curScore.nstaves; staff++) {
			cursor.staffIdx = staff;
			for (var voice = 0; voice < 4; voice++) {
				cursor.voice = voice;
				cursor.rewind(Cursor.SCORE_START);
	
				while (cursor.segment) {
					var el = cursor.element;
					if (el) {
						if (el.type == Element.CHORD) {
							fn(el);
						}
					}
					cursor.next();
				}
			}
		}
	}

	function softenChordNotes(el) {
		// notes は note.pitch (= MIDI ノートナンバー) の小さい順に並ぶ
		for (var k = 0; k < el.notes.length - 1; k++) {
			var note = el.notes[k];
			for (var prop in note) {
				note.veloOffset = -25;
			}
		}
	}

	onRun: {
		eachNotes(softenChordNotes);
		Qt.quit();
	}
}

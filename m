Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46032 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbZELWMO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 18:12:14 -0400
Received: from wireless by sipsolutions.net with local (Exim 4.69)
	(envelope-from <wireless@sipsolutions.net>)
	id 1M40Cr-0008LD-Ru
	for linux-wireless@vger.kernel.org; Wed, 13 May 2009 00:12:13 +0200
To: linux-wireless@vger.kernel.org
Subject: [ANN] iw: v0.9.14
Reply-to: linux-wireless@vger.kernel.org
Message-Id: <E1M40Cr-0008LD-Ru@sipsolutions.net>
From: wireless@sipsolutions.net
Date: Wed, 13 May 2009 00:12:13 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of iw (v0.9.14) is available at:

http://wireless.kernel.org/download/iw/iw-0.9.14.tar.bz2

SHA1 sum: e1fb8830a689dc567e05c5d83f1761d1d0cc404b

Here is the short log of the changes included in this 
release:

Johannes Berg -  v0.9.14
Johannes Berg -  finish docs
Johannes Berg -  more interface help
Johannes Berg -  help for 'set name'
Johannes Berg -  add note to set channel/freq
Johannes Berg -  print version in help output
Johannes Berg -  document scan commands
Johannes Berg -  add help for ibss commands
Johannes Berg -  add help for info/list/phy commands
Johannes Berg -  add ability to document commands, document event/help
Johannes Berg -  use C99 initialiser for cmd struct
Johannes Berg -  if command fails, print help for this command
Johannes Berg -  split out event handling code
Johannes Berg -  split out per-command help
Johannes Berg -  allow printing timing on events (-t)
Johannes Berg -  print status
Johannes Berg -  print nicer auth/assoc/deauth/disassoc events
Johannes Berg -  make event printing more regular
Johannes Berg -  print extended capabilities
Johannes Berg -  print rsn capabilities field
Johannes Berg -  add AKM suites for 11r/11w
Johannes Berg -  use decimal like the standard for suites below OUI
Johannes Berg -  print "00-0f-ac:7" instead of "Unknown (00-0f-ac:7)" to make it shorter
Johannes Berg -  print invalid tail on WPA/RSN IE if present
Marcel Holtmann -  add length checks for WPA/RSN cipher and authentication suites
Marcel Holtmann -  add support for showing power constraint IE
Johannes Berg -  rearrange some tests to be clearer
Johannes Berg -  add ability to scan certain SSIDs/frequencies
Johannes Berg -  validate IE length better in places
Johannes Berg -  add Country in/outdoor environ + invalid environ
Johannes Berg -  print WPS version as major.minor
Johannes Berg -  print unknown cipher/auth suites with more info
Johannes Berg -  s/WPA2/RSN/
Marcel Holtmann -  add support for parsing WPA and RSN/WPA2 information elements
Marcel Holtmann -  add basic support for parsing WMM information element
Marcel Holtmann -  add human readable decoding for capability information field
Marcel Holtmann -  add support for showing extended capabilities IE
Marcel Holtmann -  add basic support for parsing country information element
Marcel Holtmann -  add support for parsing ERP information element
Marcel Holtmann -  add option to dump unknown IEs with scan command
Johannes Berg -  WPS scan: print out AP locked attribute
Johannes Berg -  parse some WPS data
Johannes Berg -  print unknown IEs in nicer form
Johannes Berg -  don't try parsing too short vendor IEs
Johannes Berg -  add scan warnings

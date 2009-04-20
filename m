Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38061 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbZDTXKX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 19:10:23 -0400
Received: from wireless by sipsolutions.net with local (Exim 4.69)
	(envelope-from <wireless@sipsolutions.net>)
	id 1Lw2d2-0005G0-M8
	for linux-wireless@vger.kernel.org; Tue, 21 Apr 2009 01:10:21 +0200
To: linux-wireless@vger.kernel.org
Subject: [ANN] iw: v0.9.13
Reply-to: linux-wireless@vger.kernel.org
Message-Id: <E1Lw2d2-0005G0-M8@sipsolutions.net>
From: wireless@sipsolutions.net
Date: Tue, 21 Apr 2009 01:10:20 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of iw (v0.9.13) is available at:

http://wireless.kernel.org/download/iw/iw-0.9.13.tar.bz2

SHA1 sum: c9bb4e484c50a36d2dcc2c2be38d985b355c9a08

Here is the short log of the changes included in this 
release:

Johannes Berg -  0.9.13
Johannes Berg -  generate version.c instead of version.o
Johannes Berg -  Merge branch 'ibss-test'
Johannes Berg -  update nl80211.h
Johannes Berg -  fix bug introduced by previous commit
Johannes Berg -  adjust to new ibss API
Johannes Berg -  print better interface names
Johannes Berg -  Merge branch 'master' into ibss-test
Johannes Berg -  support "iw dev ... set type ..."
Johannes Berg -  add "dev" command to list all wireless interfaces
Johannes Berg -  add "phy" command as alias for "list"
Johannes Berg -  allow more command aliasing, dev/phy commands
Johannes Berg -  ibss join/leave/event code
Johannes Berg -  update nl80211.h
Johannes Berg -  make version.h depend on things
Johannes Berg -  remove -nogit suffix when building from tarball
Johannes Berg -  accept managed/mgd for station interface

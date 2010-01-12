Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36216 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab0ALEKK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2010 23:10:10 -0500
Received: from wireless by sipsolutions.net with local (Exim 4.71)
	(envelope-from <wireless@sipsolutions.net>)
	id 1NUY51-0002EO-Ps
	for linux-wireless@vger.kernel.org; Tue, 12 Jan 2010 05:10:07 +0100
Date: Tue, 12 Jan 2010 05:10:07 +0100
Message-Id: <E1NUY51-0002EO-Ps@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [ANN] iw: v0.9.19
Reply-to: linux-wireless@vger.kernel.org
From: wireless@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of iw (v0.9.19) is available at:

http://wireless.kernel.org/download/iw/iw-0.9.19.tar.bz2

SHA1 sum: 4546d9b2d65691fd402d7f478f661bbdde16d9ec

Here is the short log of the changes included in this 
release:

Johannes Berg (8):
      parse station event
      HT fixups
      completely unify MCS parsing
      fix ampdu spacing typo by replacing the text
      remove stray \n
      fix another typo
      make command/section non-const
      version 0.9.19

Luis R. Rodriguez (4):
      iw: add HT capability parsing for scanning
      iw: fix 'iw list' MCS set print
      iw: share mimumum ampdu spacing and maximum ampdu length prints
      iw: bring together common ht capability parsing

Marcel Holtmann (1):
      fix WMM indications for parameter printing


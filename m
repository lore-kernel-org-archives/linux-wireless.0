Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39911 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbZGJUxE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 16:53:04 -0400
Received: from wireless by sipsolutions.net with local (Exim 4.69)
	(envelope-from <wireless@sipsolutions.net>)
	id 1MPN5a-00027g-Nv
	for linux-wireless@vger.kernel.org; Fri, 10 Jul 2009 22:53:02 +0200
To: linux-wireless@vger.kernel.org
Subject: [ANN] iw: v0.9.15
Reply-to: linux-wireless@vger.kernel.org
Message-Id: <E1MPN5a-00027g-Nv@sipsolutions.net>
From: wireless@sipsolutions.net
Date: Fri, 10 Jul 2009 22:53:02 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of iw (v0.9.15) is available at:

http://wireless.kernel.org/download/iw/iw-0.9.15.tar.bz2

SHA1 sum: aa17e4e6d47f934adaa60562695ee0f09216e894

Here is the short log of the changes included in this 
release:

Johannes Berg -  bump version to 0.9.15
Johannes Berg -  print BSS status
Johannes Berg -  fix a reason string
Johannes Berg -  make connect able to wait
Johannes Berg -  remove netns stuff from nl80211.h -- not so soon
Johannes Berg -  make it possible to pass WEP keys to connect/join
Johannes Berg -  Merge branch 'master' into connect
Johannes Berg -  update to experimental nl80211.h
Johannes Berg -  fix phy0 autodetection
Johannes Berg -  Merge branch 'master' into connect
Johannes Berg -  add warning about scripts
Johannes Berg -  Merge branch 'master' into connect
Johannes Berg -  autodetect interface/phy
Johannes Berg -  fix connect help
Johannes Berg -  Merge branch 'master' into connect
Johannes Berg -  fix version script to include header and not write file twice
Johannes Berg -  connect events
Johannes Berg -  fix version script to include header and not write file twice
Johannes Berg -  note that the bitrates are non-HT
Johannes Berg -  update nl80211.h
Johannes Berg -  note that the bitrates are non-HT
Johannes Berg -  update nl80211.h
Johannes Berg -  connect API test
Johannes Berg -  print event on scan start
Johannes Berg -  fix assoc/auth event parsing
Johannes Berg -  "AP setup locked" is a u8 (bool)
Johannes Berg -  print scan info on event
Johannes Berg -  update nl80211.h
Johannes Berg -  sync nl80211.h
Karl Hiramoto -  iw/Makefile use pkg-config if passed from environmental var.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47859 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbZCZLEz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 07:04:55 -0400
Received: from wireless by sipsolutions.net with local (Exim 4.69)
	(envelope-from <wireless@sipsolutions.net>)
	id 1LmnOH-0006od-II
	for linux-wireless@vger.kernel.org; Thu, 26 Mar 2009 12:04:53 +0100
To: linux-wireless@vger.kernel.org
Subject: [ANN] iw: v0.9.11
Reply-to: linux-wireless@vger.kernel.org
Message-Id: <E1LmnOH-0006od-II@sipsolutions.net>
From: wireless@sipsolutions.net
Date: Thu, 26 Mar 2009 12:04:53 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of iw (v0.9.11) is available at:

http://wireless.kernel.org/download/iw/iw-0.9.11.tar.bz2

SHA1 sum: a945524b498d1f375e521479babe53716ef56ede

Here is the short log of the changes included in this 
release:

Johannes Berg -  0.9.11
Johannes Berg -  Revert "iw: parse max allowed bandwidth"
Johannes Berg -  allow identify wiphys by index with "phy#<idx>" rather than "phy <name>"
Johannes Berg -  better error reporting if dev/phy does not exist

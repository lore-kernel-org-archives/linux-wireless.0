Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37311 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757594Ab2C1JGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 05:06:14 -0400
Message-Id: <20120328085835.902687300@sipsolutions.net> (sfid-20120328_110618_679376_B870FC66)
Date: Wed, 28 Mar 2012 10:58:35 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] early HT channel setting
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the patchset we've discussed earlier, setting
the HT channel on authentication and later changing
only TX control to restrict to 20 MHz (or even non-HT)
as needed/desired.

This provides a better fix for Paul's Korea regulatory
problem (covering one more corner case), makes the code
easier to follow and simplifies hardware programming.

I was holding this until ath9k_htc got fixed, but now I
think it was already broken by Paul's patch and needs  
this patchset to be fixed.

johannes


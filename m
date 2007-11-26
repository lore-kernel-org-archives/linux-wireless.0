Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:3527 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754094AbXKZLn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 06:43:58 -0500
From: Bruno Randolf <bruno@thinktube.com>
To: ath5k-devel@lists.ath5k.org
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com
Subject: ath5k debugging take 2
Date: Mon, 26 Nov 2007 20:43:52 +0900
Message-Id: <1196077433-12358-1-git-send-email-bruno@thinktube.com> (sfid-20071126_114409_652369_3EAB3EE4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


hello!

this is an updated version of my debugging changes. luis i hope i have
addressed all your comments.

i have removed dumpstate to make the licensing simpler. now debug.c just
contains stuff from base.c which always was dual BSD/GPL.

debug.c and debug.h now includes the original copyright from base.c, but is
itself licensed under the GPL. i hope in this case that will not upset the
original authors since it is just debugging stuff specific to linux anyways.

bruno

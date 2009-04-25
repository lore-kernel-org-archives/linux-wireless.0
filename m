Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:32909 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171AbZDYQ0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 12:26:39 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: Warning in tx.c:775 invoke_tx_handlers
Date: Sat, 25 Apr 2009 18:23:59 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <200904251650.17142.mb@bu3sch.de> <200904251741.10310.mb@bu3sch.de> <69e28c910904250918t866e17t65ef19efc3213574@mail.gmail.com>
In-Reply-To: <69e28c910904250918t866e17t65ef19efc3213574@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200904251823.59956.mb@bu3sch.de> (sfid-20090425_182643_080096_15FD9145)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 25 April 2009 18:18:31 G=E1bor Stefanik wrote:
> I guess you aren't using the latest kernel from wireless-testing.

Well, it is 5 days old:

> [973533.018287] WARNING: at /home/mb/kernel/compat-wireless-2009-04-2=
0/net/mac80211/tx.c:775 invoke_tx_handlers+0xde4/0xe10 [mac80211]()

--=20
Greetings, Michael.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

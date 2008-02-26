Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.190]:14290 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbYBZFXE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 00:23:04 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1243645rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 21:23:03 -0800 (PST)
Reply-To: <cs010101@gmail.com>
From: =?ks_c_5601-1987?B?sei/tciv?= <cs010101@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: ath5k : test
Date: Tue, 26 Feb 2008 14:22:58 +0900
Message-ID: <006501c87837$a7ef9590$3b0aa8c0@39fb6b6b6f434b3> (sfid-20080226_052320_310990_1F4F32C5)
MIME-Version: 1.0
Content-Type: text/plain; charset=ks_c_5601-1987
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

date : 26, Feb (driver's also same)

conclusion:

setting 802.11a ad-hoc,=20

5Ghz channel is different.

and iwconfig wlanX rate [more than 24Mbps] : disconnected!

and when I testing, performance was terrible. so often stalled.

so, I made 'mod_timer' comment in base.c (calibration section) and then
performance was increased.

BUT also when I set more than 24Mb, disconnected.=20

but until now, only atheros driver supports 802.11a with ad-hoc. thanks=
=2E :-)

hmm...

soon or later, we'll test ralink chipset.


--
--
Have a Wonderful Day~~!!
=B1=E8=BF=B5=C8=AF (James-Youngwhan Kim)
yhkim@corebell.co.kr
cs010101@gmail.com
+82-42-863-0340
+82-10-6753-0987
HTVC 3106 KAIST, 373-1 Guseong-dong, Yuseong-gu,
Daejon,  Republic of Korea
305-701

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

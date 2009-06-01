Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16084 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029AbZFASl0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 14:41:26 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2009 11:41:28 -0700
Date: Mon, 1 Jun 2009 11:41:34 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: <linville@tuxdriver.com>, <Gaurav.Jauhar@atheros.com>,
	<senthilkumar@atheros.com>, <ath9k-devel@lists.ath9k.org>,
	<leann.ogasawara@canonical.com>, <tim.gardner@canonical.com>,
	<parag.warudkar@gmail.com>, <drago01@gmail.com>,
	<drjoms@gmail.com>, <jirislaby@gmail.com>, <debaditya@gmail.com>,
	<arxs@fedoraproject.org>, <michal@harddata.com>,
	<fabian.deutsch@gmx.de>
Subject: Pending ath9k bugs
Message-ID: <20090601184134.GC5516@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is a list of pending ath9k bugs, if I've missed
anything please reply to this e-mail and let us know. If you
have any insights into specific AP issues (one with Airport
Express N, another with DAP-1353) please let us know.

kernel.org:

1) "Very low signal strenghts with ath9k in 2.6.29"
	http://bugzilla.kernel.org/show_bug.cgi?id=12930
	Patch available but user still reports issues with both Windows and Linux
	with an AR5416 PCI-E card. Patch has not yet been pushed upstream.
2) "AR5008/DWA-552 - Very slow" on 2.6.30-rc2
	http://bugzilla.kernel.org/show_bug.cgi?id=13141
	Card is an AR5416 card (PCI-E), AP is "Airport Express N" in 11 mode
	with WPA. Claims under windows performance is better. User is testing
	with kerenl 2.6.30-rc2.

ath9k-devel:

1) Cannot associate with AP DAP-1353 in 11n mode, no encryption.
	First message:
	https://lists.ath9k.org/pipermail/ath9k-devel/2009-May/001566.html
	Thread:
	https://lists.ath9k.org/pipermail/ath9k-devel/2009-May/thread.html#1566

Red Hat Bugzilla:

1) " [ath9k] not able to use WLAN on channel 13 with AR5008 [168c:0024] [NEEDINFO]"
	https://bugzilla.redhat.com/show_bug.cgi?id=503285
2) "ath9k - bit rate is always reported as 1 Mb/s   [NEEDINFO]"
	https://bugzilla.redhat.com/show_bug.cgi?id=481259
3) " ath9k can not connect to hidden networks   [NEEDINFO]"
	https://bugzilla.redhat.com/show_bug.cgi?id=496505
	This is against a "linksys wpa54g" with WPA2
4) "NetworkManager requires ath9k reload to work. [NEEDINFO]"
	https://bugzilla.redhat.com/show_bug.cgi?id=489216

OpenSuse:

1) "wi-fi card Atheros AR928X returns "no scan results""
	https://bugzilla.novell.com/show_bug.cgi?id=462673
	Not sure what to make of this. Jiri might know better.

I reviewed most ath9k Ubuntu bug reports but unfortunately all are
on old stable kernel releases or old kernels, most need more info,
and I was unable to find any useful bug report which reflects the
current ath9k as is upstream or any critical fix for older stable
kernel releases. If I missed anything please do let us know.

  Luis

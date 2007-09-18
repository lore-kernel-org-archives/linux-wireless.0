Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:37773 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752953AbXIREd4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 00:33:56 -0400
Message-ID: <46EF5534.3030609@lwfinger.net>
Date: Mon, 17 Sep 2007 23:33:56 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: Jean Tourrilhes <jt@hpl.hp.com>,
	YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: Re: 2.6.23-rc regression: bcm43xx does not work after commit 4cf92a3c
References: <20070917.042418.19962472.yoshfuji@linux-ipv6.org> <20070917165435.GA26926@bougret.hpl.hp.com>
In-Reply-To: <20070917165435.GA26926@bougret.hpl.hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Yoshifuji Hideaki reported that commit 4cf92a3c broke the bcm43xx driver. I was able to duplicate
the problem with WEP encryption and ifconfig control of the device. The problem does not happen with
WPA or when using NetworkManager with WEP.

This patch was supposed to be a fix for the bug reported at
http://bugzilla.kernel.org/show_bug.cgi?id=8686; however, it does not.

This commit should be reverted before 2.6.23 is released.

Thanks,

Larry


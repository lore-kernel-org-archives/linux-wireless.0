Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:33072 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965460AbXBGEkS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Feb 2007 23:40:18 -0500
Message-ID: <45C95830.6040507@lwfinger.net>
Date: Tue, 06 Feb 2007 22:40:16 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@verizon.net>
CC: Pavel Roskin <proski@gnu.org>, bcm43xx-dev@lists.berlios.de,
	wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: RFT bcm43xx: Really _GOOD_ news
References: <45C8E64B.1050605@lwfinger.net> <200702061637.31756.gene.heskett@verizon.net> <1170800953.2613.17.camel@dv> <200702061848.00815.gene.heskett@verizon.net>
In-Reply-To: <200702061848.00815.gene.heskett@verizon.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was a bit too enthusiastic. The patch I sent earlier actually breaks the 4318. It does make 4311
and 4312's work for the wrong reason. If you have that card, you can use it in the meantime while we
find out just why it helps there.

Sorry for the false alarm, but we are making progress.

Larry


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:53441 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755139AbXIYDGi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 23:06:38 -0400
Message-ID: <46F87B27.5040106@lwfinger.net>
Date: Mon, 24 Sep 2007 22:06:15 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?WU9TSElGVUpJIEhpZGVha2kgLyDlkInol6Toi7HmmI4=?=
	<yoshfuji@linux-ipv6.org>
CC: jt@hpl.hp.com, linville@tuxdriver.com, mb@bu3sch.de,
	linux-wireless@vger.kernel.org, davem@davemloft.net,
	torvalds@linux-foundation.org
Subject: Re: 2.6.23-rc regression: bcm43xx does not work after commit 4cf92a3c
References: <20070918174202.GB1466@bougret.hpl.hp.com>	<46F09167.5020606@lwfinger.net>	<20070919163237.GA7914@bougret.hpl.hp.com> <20070925.115054.25066958.yoshfuji@linux-ipv6.org>
In-Reply-To: <20070925.115054.25066958.yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

YOSHIFUJI Hideaki / =E5=90=89=E8=97=A4=E8=8B=B1=E6=98=8E wrote:
> Hello.
>=20
> What is the status of this issue?
> 2.6.23-rc8 does not help me.
>=20
> Regression is not right even if the change does
> "fix" some aspects.   Please apply the "right" fix
> or revert it before 2.6.23.

The right fix is in the chain. I sent it to John Linville who has sent =
it to Jeff Garzik. I
certainly hope it makes it before 2.6.23, as it is a serious regression=
=2E

Do you have the patch that fixes it? If not, please let me know and I'l=
l send it to you.

Larry

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jubileegroup.co.uk ([217.147.177.250]:54943 "EHLO
	mail.jubileegroup.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932992Ab2HVREB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2012 13:04:01 -0400
Date: Wed, 22 Aug 2012 18:00:32 +0100 (BST)
From: "G.W. Haywood" <ged@jubileegroup.co.uk>
To: Hauke Mehrtens <hauke@hauke-m.de>
cc: Bastian Bittorf <bittorf@bluebottle.com>,
	openwrt-devel@lists.openwrt.org, linux-wireless@vger.kernel.org,
	feint@lists.subsignal.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: WRT54g / b43 / mac802.11 BREAKTHROUGH
In-Reply-To: <50350706.609@hauke-m.de>
Message-ID: <Pine.LNX.4.64.1208221728500.31425@mail5.jubileegroup.co.uk> (sfid-20120822_190418_516108_A83B365F)
References: <1342612598.5006a476022c6@mail.bluebottle.com> <50350706.609@hauke-m.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi there,

On Wed, 22 Aug 2012, Hauke Mehrtens wrote:

> ...  If the Access Points sends the traffic the
> problem occurs, if it is just receiving there is not problem.

Interesting.  I have not specifically tested my Linksys devices by
sending files from client to access point and vice-versa, but I can
say that the problem exists (well at least, a problem exists) when the
two stations are in ad-hoc mode, and so neither of them is acting as
an access point.  The symptoms are the same: at high loads (megabits
per second), the wireless communication quickly fails (a few seconds)
and manual intervention is then required to recover the wireless link
by reconfiguring one or other of the interfaces.  To recap, this is
OpenWRT built last week from trunk runing on Linksys WRT54GSv1.1.

The same equipment appears to function perfectly well at high loads
when using other firmware (Tomato version 1.28).

Unfortunately I do not have Broadcom devices which I can test on x86
but if someone can suggest suitable cards I will consider a purchase.
There are x86 boxes here which I can use for testing.  It is certain
that I would need a few pointers to build a system which will perform
tests likely to provide useful information about the problem but I am
very familiar with the "./configure/make/make install" routine.

--

73,
Ged.

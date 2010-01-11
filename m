Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:39000 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab0AKWmM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2010 17:42:12 -0500
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [PATCH 3/6] b43: N-PHY: add RSSI calculation for PHY rev < 3
Date: Mon, 11 Jan 2010 23:42:07 +0100
Cc: bcm43xx-dev@lists.berlios.de,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
References: <op.u6b70wtk9lhzdc@linux-g0th.site> <201001112313.26197.mb@bu3sch.de> <b170af451001111427u25861f2bla4062a7b0aea19ec@mail.gmail.com>
In-Reply-To: <b170af451001111427u25861f2bla4062a7b0aea19ec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001112342.08099.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 11 January 2010 23:27:18 Rafał Miłecki wrote:
> Whoops, I should have explained what I mean. I am not sure what CFLAGS
> "make" picks for compiled but I get:
> 
>   CC [M]  drivers/net/wireless/b43/phy_n.o
> drivers/net/wireless/b43/phy_n.c: In function ‘b43_nphy_rev2_rssi_cal’:
> drivers/net/wireless/b43/phy_n.c:887: warning: missing braces around initializer
> drivers/net/wireless/b43/phy_n.c:887: warning: (near initialization
> for ‘results[0]’)
> 
> for s32 results[4][4] = { 0, };
> 

But does this work?
s32 results[4][4] = { };

-- 
Greetings, Michael.

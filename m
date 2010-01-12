Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.216.174]:59197 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab0ALVrt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 16:47:49 -0500
Received: by pxi4 with SMTP id 4so4948138pxi.33
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jan 2010 13:47:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B4CCB56.2080609@spectraaccess.net>
References: <995709e41001091103t43738262ibb2c4e0c4beab26d@mail.gmail.com>
	<995709e41001120724j7a6627b1g5d90df8fb658ceaa@mail.gmail.com>
	<43e72e891001120846x453e4052oa93675b86fe4a86d@mail.gmail.com>
	<995709e41001120914n17cfdb56k664c2b42afe448f6@mail.gmail.com>
	<995709e41001120915h1a156606m837717ffd584fa3e@mail.gmail.com>
	<20100112180438.GA17003@infradead.org> <20100112183047.GI17243@tux>
	<20100112183202.GA21982@infradead.org> <20100112183735.GL17243@tux>
	<4B4CCB56.2080609@spectraaccess.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 12 Jan 2010 13:47:28 -0800
Message-ID: <43e72e891001121347r35248eb2k3969166163507183@mail.gmail.com>
Subject: Re: [ath9k-devel] [Moblin Dev] Wireless is keep on disconnecting
To: Bret Clark <bac522@spectraaccess.net>
Cc: "dev@moblin.org" <dev@moblin.org>, alainswb <alainswb@free.fr>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Christoph Hellwig <hch@infradead.org>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Jouni Malinen <Jouni.Malinen@atheros.com>,
	Jaswinder Singh Rajput <jaswindermobile@gmail.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 12, 2010 at 11:19 AM, Bret Clark <bac522@spectraaccess.net> wrote:
>
> There is only one.  And most rcs weren't bootable on my laptop, so I
> couldn't bisect it.
>
>
> Well what I mean is have you tried, say 2.6.32.3 by any chance?
>
>   Luis
>
> I've had a very similar issue myself and I did try kernel 2.6.32.3 with the
> latest driver date 12-11. On the AP at work, which is a Linksys WRP400 the
> driver works great, but at my house on my Netgear WGR614v6, the wireless is
> pretty much unusable and exhibits the same symptoms the original poster has.

Your description lacks a lot of information to in any way help you.
Note the original post on this thread was about ath9k, Christoph then
mentioned issues with an Intel card. Please ensure to read:

http://wireless.kernel.org/en/users/Documentation/Reporting_bugs

Reporting issues with more details would likely help developers assist
you with your issues.

  Luis

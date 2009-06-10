Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36256 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbZFJLpa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 07:45:30 -0400
Date: Wed, 10 Jun 2009 07:31:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	=?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	Stefan Steuerwald <salsasepp@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Testing AP mode with WLAN-USB-Stick: How to obtain?
Message-ID: <20090610113158.GA2798@tuxdriver.com>
References: <f76a32050906081007q19e9361w8c1fad6fc73c47e7@mail.gmail.com> <f76a32050906081011o589474f2geba321c58c0872c2@mail.gmail.com> <3ace41890906081659o23cb9ee1sd82ca4fc28a3793d@mail.gmail.com> <69e28c910906090426l4c383665rdc4bffc501085661@mail.gmail.com> <3ace41890906092018o76b0ee62n91819779a8ccd6db@mail.gmail.com> <1244619027.18481.55.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1244619027.18481.55.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 10, 2009 at 09:30:27AM +0200, Johannes Berg wrote:

> This means that your sleeping clients will not be receiving multicast,
> and as such be invisible to the network once they fall off the ARP/NDP
> caches. This is the reason we have said that it will not be possible to
> support AP mode with this card. I'm curious how, if at all, the vendor
> driver handles that.

My completely uninformed guess is that they ignore it.  I will hazard
a guess that most scenarios involving "laptop as AP" are for support
of devices that don't (or at least didn't) do a lot of sleeping,
like other laptops.

I'm still a bit "on the fence" regarding this requirement for AP mode.
I think there is a reasonable body of users that would prefer a
not-quite-right AP mode over no AP mode at all.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

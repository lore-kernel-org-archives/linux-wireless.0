Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36659 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbYKNObL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 09:31:11 -0500
Date: Fri, 14 Nov 2008 09:19:13 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stefanik =?iso-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: Kalle Valo <kalle.valo@nokia.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Mark Ryden <markryde@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Master mode in iw
Message-ID: <20081114141912.GB3443@tuxdriver.com> (sfid-20081114_153116_380795_6C886184)
References: <dac45060811130246n41c9983fx2f06f85946b20c1c@mail.gmail.com> <87ej1f6ggq.fsf@nokia.com> <dac45060811130349k3153fcd6i9e6f35f9df3f52ef@mail.gmail.com> <87wsf74z6f.fsf@nokia.com> <1226578011.5105.8.camel@johannes.berg> <87fxlu4rdx.fsf@nokia.com> <69e28c910811140539p57fa13dej4c13aa0d09c76f95@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <69e28c910811140539p57fa13dej4c13aa0d09c76f95@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 14, 2008 at 02:39:50PM +0100, Stefanik G=E1bor wrote:
> On Fri, Nov 14, 2008 at 9:56 AM, Kalle Valo <kalle.valo@nokia.com> wr=
ote:

> > Actually I was thinking about fullmac hardware which support AP mod=
e.
> > In theory we might need to support those, but I guess in practise
> > there hasn't been, nor ever will be, such hardware. I'll just shut =
up
> > now :)

> I doubt that any fullmac hardware should have a mac80211-based driver=
=2E..

cfg80211 !=3D mac80211

--=20
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

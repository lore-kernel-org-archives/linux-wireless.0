Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36868 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758367AbZFJUAf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 16:00:35 -0400
Date: Wed, 10 Jun 2009 15:58:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jouni Malinen <j@w1.fi>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	Johannes Berg <johannes@sipsolutions.net>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	=?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	Stefan Steuerwald <salsasepp@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Testing AP mode with WLAN-USB-Stick: How to obtain?
Message-ID: <20090610195857.GF3892@tuxdriver.com>
References: <f76a32050906081007q19e9361w8c1fad6fc73c47e7@mail.gmail.com> <f76a32050906081011o589474f2geba321c58c0872c2@mail.gmail.com> <3ace41890906081659o23cb9ee1sd82ca4fc28a3793d@mail.gmail.com> <69e28c910906090426l4c383665rdc4bffc501085661@mail.gmail.com> <3ace41890906092018o76b0ee62n91819779a8ccd6db@mail.gmail.com> <1244619027.18481.55.camel@johannes.local> <20090610113158.GA2798@tuxdriver.com> <87ws7jsxqt.fsf@litku.valot.fi> <20090610192825.GA23353@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090610192825.GA23353@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 10, 2009 at 10:28:25PM +0300, Jouni Malinen wrote:

> I don't like the idea of making hostapd warn the user somehow, but could
> probably live with something like AP mode being implemented in the
> driver, but disabled by default. Only if the user were to use a module
> parameter, say, broken_ap_mode=1, would the support for AP mode be
> registered. As long as distros do not start adding this parameter by
> default, this would force the user to become at least somehow informed
> about the issues and make a conscious choice in enabling the mode.

I would probably lean the other way -- let the driver expose the fact
that his AP mode is dysfunctional, and require hostap to say it is OK
to use it.  Then again, it is the kind of thing that a user will say
"OK" and then go on to file bug reports about the problems created
by broken AP mode drivers...

Like I said, "on the fence"... :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

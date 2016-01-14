Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45034 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbcANJQ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2016 04:16:58 -0500
Date: Thu, 14 Jan 2016 10:16:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arend van Spriel <arend@broadcom.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Gnedt <david.gnedt@davizone.at>
Subject: Re: [PATCH v2] wl1251: add sysfs interface for bluetooth coexistence
 mode configuration
Message-ID: <20160114091654.GA15380@amd> (sfid-20160114_101750_777507_A7A04140)
References: <1451130310-16666-1-git-send-email-pali.rohar@gmail.com>
 <5696D08F.9030906@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <5696D08F.9030906@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed 2016-01-13 23:32:47, Arend van Spriel wrote:
> On 12/26/2015 12:45 PM, Pali Rohár wrote:
> >Port the bt_coex_mode sysfs interface from wl1251 driver version included
> >in the Maemo Fremantle kernel to allow bt-coexistence mode configuration.
> >This enables userspace applications to set one of the modes
> >WL1251_BT_COEX_OFF, WL1251_BT_COEX_ENABLE and WL1251_BT_COEX_MONOAUDIO.
> >The default mode is WL1251_BT_COEX_OFF.
> >It should be noted that this driver always enabled bt-coexistence before
> >and enabled bt-coexistence directly affects the receiving performance,
> >rendering it unusable in some low-signal situations. Especially monitor
> >mode is affected very badly with bt-coexistence enabled.
> 
> So what user-space process will be using this interface. Did you consider
> adding debugfs interface? In case of monitor mode you could consider
> disabling bt-coex from within the driver itself.

This aint no debugging feature.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

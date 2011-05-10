Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm22.bullet.mail.bf1.yahoo.com ([98.139.212.181]:46356 "HELO
	nm22.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752436Ab1EJPXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 11:23:50 -0400
Message-ID: <152413.98046.qm@web161612.mail.bf1.yahoo.com> (sfid-20110510_172353_623661_3588B3C7)
Date: Tue, 10 May 2011 08:23:49 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [PATCH 3/3] compat-wireless: enable RT33XX and RT53XX support.
To: Hauke Mehrtens <hauke@hauke-m.de>,
	Ivo Van Doorn <ivdoorn@gmail.com>
Cc: mcgrof@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
In-Reply-To: <BANLkTimp10vXTRkC7mBgDX97aiE+Eo_seg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The following config options are all marked as unstable
> (they depend
> on EXPERIMENTAL)
>  RT2800PCI_RT35XX
>  RT2800PCI_RT53XX
>  RT2800USB_RT35XX
>  RT2800USB_RT53XX

So this basically means everything above 33+ is experimental at this point. RT33xx should only be enabled now, per my original patch.

Walter
-------

// Side note to Luis,
compat-wireless tar balls aren't being uploaded to orbit and kernel, despite the successful emails from the cron bot. Last uploaded CW archive was 5 days ago, can you look that up? //

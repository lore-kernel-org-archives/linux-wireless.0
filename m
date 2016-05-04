Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46705 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265AbcEDH3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2016 03:29:40 -0400
Date: Wed, 4 May 2016 09:29:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: =?iso-8859-1?Q?Jo=E3o?= Paulo Rechi Vita <jprvita@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@endlessm.com,
	=?iso-8859-1?Q?Jo=E3o?= Paulo Rechi Vita
	<jprvita@endlessm.com>
Subject: Re: [RESEND PATCH 1/3] rfkill: Create "rfkill-airplane-mode" LED
 trigger
Message-ID: <20160504072936.GB17045@amd> (sfid-20160504_093003_246697_50EB04BA)
References: <1462199948-6424-1-git-send-email-jprvita@endlessm.com>
 <1462199948-6424-2-git-send-email-jprvita@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1462199948-6424-2-git-send-email-jprvita@endlessm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

> This creates a new LED trigger to be used by platform drivers as a
> default trigger for airplane-mode indicator LEDs.
> 
> By default this trigger will fire when RFKILL_OP_CHANGE_ALL is called
> for all types (RFKILL_TYPE_ALL), setting the LED brightness to LED_FULL
> when the changing the state to blocked, and to LED_OFF when the changing
> the state to unblocked. In the future there will be a mechanism for
> userspace to override the default policy, so it can implement its
> own.

If userspace wants to control the manually, it can do just that --
control it manually. There should not be a need to "override the
default policy".
								Pavel
								
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

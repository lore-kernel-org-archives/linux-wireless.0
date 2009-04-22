Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:53449 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZDVTpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 15:45:33 -0400
Received: by fxm2 with SMTP id 2so162414fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 22 Apr 2009 12:45:31 -0700 (PDT)
To: Bob Copeland <me@bobcopeland.com>
Cc: kalle.valo@nokia.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/6] wl12xx updates
References: <1238897428-19639-1-git-send-email-me@bobcopeland.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 22 Apr 2009 22:45:30 +0300
In-Reply-To: <1238897428-19639-1-git-send-email-me@bobcopeland.com> (Bob Copeland's message of "Sat\,  4 Apr 2009 22\:10\:22 -0400")
Message-ID: <87skk0ealh.fsf@litku.valot.fi> (sfid-20090422_214537_160520_6D724D18)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> Hi Kalle,

Hi Bob,

> Here are some patches that bring wl12xx back to compiling state for
> current wireless-testing.  This is on top of your original patch
> from your web page.  Review at your leisure, and feel free to roll
> them all up into your eventual post for inclusion.
>
> Of note, possible incompatible changes are patch 2 which removes ssid
> from the join command, and patch 3 which changes the platform setup
> so it can compile on any platform.  Only compile-tested for now.

Very cool! I took latest wl12xx code and applied your patches on top of
that. I managed to get working connection with 2.6.30-rc2-omap1 (from
linux-omap). So your patches work in a real device.

I'll send all the patches later tonight and try to convince John to take
wl12xx to wireless-testing.

-- 
Kalle Valo

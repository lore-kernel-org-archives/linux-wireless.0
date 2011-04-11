Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49079 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab1DKQMf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 12:12:35 -0400
Received: by pvg12 with SMTP id 12so2037478pvg.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2011 09:12:35 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19875.10497.371960.179673@gargle.gargle.HOWL>
Date: Mon, 11 Apr 2011 21:44:57 +0530
To: Richard Farina <sidhayn@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: ath9k_htc oddity
In-Reply-To: <4DA326A9.9060904@gmail.com>
References: <4D9FCC70.1020805@gmail.com>
	<19871.62035.829719.402615@gargle.gargle.HOWL>
	<4DA311F3.6010007@gmail.com>
	<19875.7684.859710.807182@gargle.gargle.HOWL>
	<4DA326A9.9060904@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Richard Farina wrote:
> Sorry for being a bit dim on this but which part of this exactly fixes 
> the ethtool driver function?  I'm guessing it is in the patchset and the 
> firmware is only required if I want to detect the firmware version? Or 
> do I really need experimental firmware to make it detect the driver 
> properly?

The ethtool fix is part of the patchset (specifically patch no. 3),
and the new FW is required if the patchset is used.

> Also, when you say experimental do you mean it's all pretty experimental 
> or just the AP stuff is? I'm guessing the firmware is based on the 
> current firmware so the station mode et al should be (approximately) as 
> stable at the released firmware and only the AP parts are experimental.

Yes, the new version is based on the current FW and the AP stuff is experimental.
Station mode should ideally not have any problems, but since the firmware
has had a fairly invasive cleanup, one can never know. :)

Sujith

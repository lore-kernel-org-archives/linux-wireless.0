Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43216 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab0EFJL6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 05:11:58 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 06 May 2010 02:11:58 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19426.34789.799371.633305@gargle.gargle.HOWL>
Date: Thu, 6 May 2010 14:42:05 +0530
To: Kalle Valo <kvalo@adurom.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 07/11] ath9k_htc: Use USB reboot
In-Reply-To: <87zl0mjkx7.fsf@purkki.valot.fi>
References: <19409.10472.450708.915467@gargle.gargle.HOWL>
	<87zl0mjkx7.fsf@purkki.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> Sujith <Sujith.Manoharan@atheros.com> writes:
> 
> > So, apparently there is a USB reboot command
> > that the target accepts. Using this instead of
> > usb_reset_device() fixes the issue of "descriptor read error"
> > that pops up on repeated load/unload.
> 
> [...]
> 
> > +static void ath9k_hif_usb_reboot(struct usb_device *udev)
> > +{
> > +	u32 reboot_cmd = 0xffffffff;
> 
> A define for the actual command value would be nice here.

Sorry, I was out and John has merged this patch.
Will do this later, thanks for the review.

Sujith

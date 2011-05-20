Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:41609 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933726Ab1ETO0P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 10:26:15 -0400
Subject: Re: Plan for ath6kl cleanup
From: Marcel Holtmann <marcel@holtmann.org>
To: Kalle Valo <kalle.valo@atheros.com>
Cc: linux-wireless@vger.kernel.org, gregkh@suse.de,
	linville@tuxdriver.com, devel@linuxdriverproject.org
In-Reply-To: <4DD668F4.6090308@atheros.com>
References: <4DD668F4.6090308@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 07:26:03 -0700
Message-ID: <1305901563.2681.9.camel@aeonflux> (sfid-20110520_162619_115903_D29E60CC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> We have been thinking about how to get ath6kl out from staging and get
> it to a first class citizen under drivers/net/wireless. There's quite a
> lot of work to do get ath6kl cleaned up and the prospect of doing all
> that through the staging-next tree wasn't that exciting. We would be
> sending hundreds of patches and it would take a long time to cleanup the
> driver. And the disconnection from the wireless core development also
> sounded very daunting (cfg80211 API changes etc.).

my main question is why do you still bother with this driver and not
re-write it as a mac80211 driver from scratch. It seems to be more
softmac than fullmac anyway. Or am I mistaken here?

The source code of the current staging driver is 5 MB in size. That is
by far the largest staging driver. Even brcm80211 is smaller.

Regards

Marcel



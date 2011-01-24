Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48832 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab1AXIjm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 03:39:42 -0500
Received: by wyb28 with SMTP id 28so3825321wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 00:39:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D3D3870.2090408@lockie.ca>
References: <4D3D3870.2090408@lockie.ca>
Date: Mon, 24 Jan 2011 14:09:41 +0530
Message-ID: <AANLkTimZw=+j9EV-34pMCTbm1KV=T1yn358PN_UZB+xn@mail.gmail.com>
Subject: Re: Failed to stop TX DMA! is new
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: James <bjlockie@lockie.ca>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 24, 2011 at 1:59 PM, James <bjlockie@lockie.ca> wrote:
> I get few or no results when I do
> iwlist wlan1 scan with kernel 2.6.37
>
> I tried kernel-2.6.38-rc2
>
> ieee80211 phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81
> mem=0xffffc900017a0000, irq=18
> ath: Failed to stop TX DMA in 100 msec after killing last frame
> ath: Failed to stop TX DMA!
>
> I noticed those Failed to stop are new messages.

I think it was there for some time.

>
> kernel-2.6.36-2 works fine.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

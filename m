Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56099 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab1ATIff convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 03:35:35 -0500
Received: by wyb28 with SMTP id 28so362752wyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 00:35:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D37E2A9.6010209@lockie.ca>
References: <4D37E2A9.6010209@lockie.ca>
Date: Thu, 20 Jan 2011 14:05:34 +0530
Message-ID: <AANLkTikhpK09=wyq=g6kHbsgd-C13A4Vc1TrA29utd5k@mail.gmail.com>
Subject: Re: ath9k problem with kernel 2.6.37
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: James <bjlockie@lockie.ca>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 20, 2011 at 12:52 PM, James <bjlockie@lockie.ca> wrote:
> phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81
> mem=0xffffc90001880000, irq=17
>
> I get few or no results when I do
> iwlist wlan1 scan with kernel 2.6.37
>

We will check it out

> but it is consistently good with kernel 2.6.36.2
>
> Is there a way to compare the kernel configs to make sure I didn't
> change anything?

Please try with latest compat wireless, which might be helpful

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

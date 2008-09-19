Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:51219 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbYISF5u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 01:57:50 -0400
Received: by yx-out-2324.google.com with SMTP id 8so49401yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 22:57:48 -0700 (PDT)
Message-ID: <43e72e890809182257r65da8757g1de0ce4f132bf019@mail.gmail.com> (sfid-20080919_075910_170016_8805CBD1)
Date: Thu, 18 Sep 2008 22:57:48 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: stlc45xx: mac80211 driver for N800 and N810
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <877i98iw4h.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <877i98iw4h.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 18, 2008 at 9:43 PM, Kalle Valo <kalle.valo@nokia.com> wrote:
> Hello all,
>
> Nokia yesterday published stlc45xx, which is a mac80211 driver for
> N800 and N810. Webpage here:
>
> http://stlc45xx.garage.maemo.org/
>
> The driver has been implemented with support from ST NXP Wireless, the
> chip manufacturer for stlc4550 and stlc4560 found in N800 and N810,
> respectively.
>
> After the driver has received some serious cleanup I would like to try
> to to get it into wireless-testing tree. But I'll send another email
> later on.

Cool! I thought n810 basically used a p54 type chipset over SPI?

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:33834 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933032AbZKDVzj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 16:55:39 -0500
Received: by iwn10 with SMTP id 10so5309759iwn.4
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2009 13:55:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4AF1F7F2.1020806@irobot.com>
References: <4AF0D54D.4090303@irobot.com> <200911041653.33737.chunkeey@googlemail.com>
	<alpine.DEB.2.00.0911050951000.16407@kauri.acheron.indranet.co.nz>
	<200911042242.48991.chunkeey@googlemail.com> <4AF1F653.4000905@irobot.com>
	<43e72e890911041350i75108dc3g454ab8577d8abacd@mail.gmail.com>
	<4AF1F7F2.1020806@irobot.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 4 Nov 2009 13:55:25 -0800
Message-ID: <43e72e890911041355l2ad1368fv277fce5b30f81877@mail.gmail.com>
Subject: Re: compat-wireless and minstrel
To: Adam Wozniak <awozniak@irobot.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Derek Smithies <derek@indranet.co.nz>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 4, 2009 at 1:53 PM, Adam Wozniak <awozniak@irobot.com> wrote:
> My guess from this is that I'm using the single stage:
>
> # dmesg | grep ar9170
> [  273.608189] usb 2-1: firmware: requesting ar9170.fw
> [  274.019650] Registered led device: ar9170-phy1::tx
> [  274.019698] Registered led device: ar9170-phy1::assoc
> [  274.019751] usbcore: registered new interface driver ar9170usb

Affirmative.

  Luis

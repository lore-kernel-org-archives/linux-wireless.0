Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:62648 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759279Ab1F1RMo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 13:12:44 -0400
Received: by yia27 with SMTP id 27so165121yia.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jun 2011 10:12:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=Smty80ARN5JLfUAXwHjAXWykZTg@mail.gmail.com>
References: <BANLkTim0mV230taAmbTm_Rm0wfPBGAznhw@mail.gmail.com>
	<201106141612.11117.chunkeey@googlemail.com>
	<BANLkTi=6=KHkPLeZawhoK3=9Ysk2C-PQHA@mail.gmail.com>
	<BANLkTi=Smty80ARN5JLfUAXwHjAXWykZTg@mail.gmail.com>
Date: Tue, 28 Jun 2011 19:12:43 +0200
Message-ID: <BANLkTimDKeLjqOhdcn9J3jNtKHygmBy3Rw@mail.gmail.com> (sfid-20110628_193608_436976_92AC36F2)
Subject: Re: DWA-160
From: Thomas Novin <thomas@xyz.pp.se>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 28, 2011 at 11:48 AM, Thomas Novin <thomas@xyz.pp.se> wrote:
> I didn't get the UWA-BR100 with Atheros chip but instead with Ralink
> chip. There are (at least) two versions of it.
>
> http://www.wikidevi.com/wiki/Talk:Sony_UWA-BR100
> http://www.wikidevi.com/wiki/Buffalo_WLI-UC-AG300N
>
> Maybe TP-Link TL-WN821Nv3 is a better choice.
>
> http://linuxwireless.org/en/users/Drivers/ath9k_htc/devices

Actually, I got the one with Atheros (if there even is one with
Ralink, I think that might just be a mixup with USB IDs). Some
confusing info on wikidevi.com lead me wrong.

It doesn't work out-of-the-box with compat-wireless but I think it
will soon. I subscribed to the ath9k-devel mailinglist and got help
with a patch to the source of ath9k_htc. After a little fix, the
driver works with UWA-BR100.

Discussion + patch here:

https://lists.ath9k.org/pipermail/ath9k-devel/2011-June/006441.html

Rgds//Thomas

Ps. I get about 60-80Mbps upstream and 50Mbps downstream connected to
my Ubiquiti Power AP-N w/ 20MHz channel width.

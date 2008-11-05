Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:37405 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbYKEVWG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 16:22:06 -0500
Received: by yw-out-2324.google.com with SMTP id 9so124731ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2008 13:22:05 -0800 (PST)
Message-ID: <43e72e890811051322m43efbf03gd21770be382e807d@mail.gmail.com> (sfid-20081105_222213_193897_F41675CF)
Date: Wed, 5 Nov 2008 13:22:04 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: msan <msan@email.it>
Subject: Re: problems with ath5k driver.
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <get27e$ka2$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <geiib4$apo$2@ger.gmane.org>
	 <20081103191625.4rwqio60gsgs0gso-cebfxv@webmail.spamcop.net>
	 <get27e$ka2$1@ger.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 5, 2008 at 1:12 PM, msan <msan@email.it> wrote:
> Il Mon, 03 Nov 2008 19:16:25 -0500, Pavel Roskin ha scritto:
>
>> Quoting msan <msan@email.it>:
>>
>>> I have an Esprimo D9500 Fujitsu Semens notebook. My lspci reports for
>>> wireless card: "06:00.0 Ethernet controller: Atheros Communications
>>> Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 04)"
>>> Dmesg says: "ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY:
>>> 0x70)".
>>
>> This device is only supported in Linux 2.6.27 and newer.
>
> Now I've installed debian package for Linux 2.6.27 taken from http://
> kernel-archive.buildserver.net/debian-kernel/pool/main/l/linux-2.6/
> and I have the same message from kernel:
>
> "ath5k phy0: Support for RF2425 is under development."
>
> So it doesn't work even with linux 2.6.27.

Now that you are on 2.6.27 try compat-wireless:

http://wireless.kernel.org/en/users/Download

This gets you bleeding edge. Or you can also just try wireless-testing directly.

  Luis

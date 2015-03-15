Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:10814 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbbCOLjK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 07:39:10 -0400
Message-ID: <55056F5C.9060903@broadcom.com> (sfid-20150315_123915_122635_E4EF26FB)
Date: Sun, 15 Mar 2015 12:39:08 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Koen Bulcke <koen.bulcke@gmail.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: Broadcom 43340
References: <550482A2.3080803@gmail.com> <55048833.90408@broadcom.com> <55048BB1.9080906@gmail.com> <550491DA.6030105@broadcom.com> <loom.20150315T024445-345@post.gmane.org>
In-Reply-To: <loom.20150315T024445-345@post.gmane.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/15/15 03:03, Koen Bulcke wrote:
> Hi,
>
> Finally I got some progress thanks to your comment,
> I can now see the Wifi
> networks on my Asus X205TA (kernel 4.0RC3).
> However, connecting to any
> network seems still to be an issue:
>
> vempc:~$ sudo wpa_supplicant -Dwext -iwlan0 -cwpa.conf

Forget about wext and try nl80211 driver so:

$ sudo wpa_supplicant -Dnl80211 -iwlan0 -cwpa.conf

Regards,
Arend

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36160 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758257Ab2FTWaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 18:30:19 -0400
Received: by wgbds11 with SMTP id ds11so4066873wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 15:30:18 -0700 (PDT)
Message-ID: <4FE24EF4.5010607@gmail.com> (sfid-20120621_003025_965646_7BB943DC)
Date: Thu, 21 Jun 2012 00:30:12 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: Erwin Van de Velde <erwin.vandevelde@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: ath9k bug in country domain handling
References: <4FDE1EF5.9030805@gmail.com> <4283314.5zPdis6seJ@sylvesterjr.cmi.ua.ac.be> <CAGRGNgXaWHMi3xDygVAzDcm6qLnHPO2nXnidPW6K+e-v1=Hm3Q@mail.gmail.com>
In-Reply-To: <CAGRGNgXaWHMi3xDygVAzDcm6qLnHPO2nXnidPW6K+e-v1=Hm3Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/19/2012 01:46 AM, Julian Calaby wrote:

> As I explained previously, the cards are tuned and configured for a
> particular regulatory domain when they're manufactured. The driver
> cannot assume that the card will be capable of complying with another
> regulatory domain.

That's false.

Atheros does not produce distinct chips for different countries or
markets.

<http://marc.info/?l=linux-wireless&m=125072768530674>

There is only ONE chip, with custom "regdomain" values in the EEPROM.
And the *driver* applies constraints based on that value. No more no less.
Then, crda/wireless-regdb only can narrows things a bit more.


Atheros chips can go beyond IEEE 802.11 frecuencies.

dd-wrt is selling "DD-WRT Superchannel Extension":
http://www.dd-wrt.com/shop/catalog/product_info.php?cPath=22&products_id=717
[...]
SuperChannel allows you to use special frequencies
from 2.3 Ghz - 2.7 Ghz (802.11g capable devices only)
and 4.9 Ghz - 6.1 Ghz (802.11a capable devices only).
[...]
Please note that the DD-WRT Superchannel license can only be
applied to certain routers equipped with Atheros based WLAN-hardware.
http://www.qsl.net/kb9mwr/projects/wireless/ddwrt-ham.jpg

Mikrotik also sells a 'code' to unlock "custom" frequencies:
http://www.mikrotik.com/documentation//manual_2.7/Interface/Wireless.html#ht2761782821

Ubiquiti used to do it: http://www.qsl.net/kb9mwr/projects/wireless/airos-ham.jpg



You can read further info in: http://www.qsl.net/kb9mwr/projects/wireless/modify.html

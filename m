Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:55811 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaI3LIS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 07:08:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH V4] bcma: use chipcommon node from DT for SoC GPIO chip
Date: Tue, 30 Sep 2014 13:08:07 +0200
Message-ID: <2792546.1ci4Y7Hkk3@wuerfel> (sfid-20140930_130823_712975_C6C38422)
In-Reply-To: <1412074548-14614-1-git-send-email-zajec5@gmail.com>
References: <1412072546-3529-1-git-send-email-zajec5@gmail.com> <1412074548-14614-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 30 September 2014 12:55:48 Rafał Miłecki wrote:
> This will allow us to define GPIO-attached devices (LEDs, buttons) in
> the the device tree.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> This is based on top of
> [PATCH v6] bcma: register bcma as device tree driver
> that I hope will reach wireless-next git tree.
> 
> V2: Describe axi chilren and make gpio a child of chipcommon core.
> V3: Make chipcommon a GPIO controller (avoid extra sub-child)
>     Speed up finding OF node in driver_gpio.c
> V4: Simplify setting of_node in driver_gpio.c
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52320 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab1DJSMn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 14:12:43 -0400
Received: by wya21 with SMTP id 21so4242770wya.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Apr 2011 11:12:42 -0700 (PDT)
Message-ID: <4DA1F316.4030301@gmail.com>
Date: Sun, 10 Apr 2011 20:12:38 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Ivo Van Doorn <ivdoorn@gmail.com>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: Firmware files for Ralink RT28x0
References: <4DA1E90A.5070902@gmail.com> <BANLkTimp6h9x0JC0HzSpKzdbKLOw=ioUvw@mail.gmail.com>
In-Reply-To: <BANLkTimp6h9x0JC0HzSpKzdbKLOw=ioUvw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/10/2011 07:35 PM, Ivo Van Doorn wrote:

> True, but the rt2860 and rt2870 firmware file are outdated in the
> linux-firmware,
> and probably don't support the rt3090 or other more recent chipsets. So before
> they can be removed, those files must be updated.

Larry Finger sent a patch to remove the rt28{6,7}0 staging drivers.
So the rt3070.bin rt3071.bin rt3090.bin files in linux-firmware
also can be removed, because they are included _only_ in the rt28{6,7}0 
staging drivers.

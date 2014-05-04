Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:34206 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbaEDMA3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2014 08:00:29 -0400
Received: by mail-lb0-f180.google.com with SMTP id p9so244587lbv.39
        for <linux-wireless@vger.kernel.org>; Sun, 04 May 2014 05:00:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <zarafa.53660170.0441.6aa863343df6b74b@srv1.localhost>
References: <zarafa.53660170.0441.6aa863343df6b74b@srv1.localhost>
Date: Sun, 4 May 2014 05:00:28 -0700
Message-ID: <CANUX_P14UWZ8DcbwQSJ+pSm-rBR6ReWUeBzeFwfg1bcfHa4RFw@mail.gmail.com> (sfid-20140504_140119_736717_2B624E90)
Subject: Re: Issue with monitor mode - iwlwifi - 7260 rev 73 - Microcode SW error
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Stefan Bauer <stefan.bauer@cubewerk.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 4, 2014 at 1:59 AM, Stefan Bauer <stefan.bauer@cubewerk.de> wrote:
> Dear Developers,
>
> after putting the card into monitor mode with airmon-ng start wlan0 i see instantly a Microcode SW error.
> From time to time, i can also produce a kernel oops.
>
> Hardware is a IBM/Lenovo S440 Laptop with
> Intel 7260 rev73 wlan card
> Kernel is 3.13.10-1
> Lenovo-Laptop-Bios is latest from lenovo webpage
> IWLWIFI Firmware is 22.24.8
>

Ok - this is surely a firmware bug.
Would you be able to open a bugzilla.kernel.org ticket for that?
I an open it for you if needed.
If you do open a ticket, please CC ilw@linux.intel.com to the bug.

Thank you.

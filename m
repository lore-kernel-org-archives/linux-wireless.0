Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46849 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab1KUSr0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 13:47:26 -0500
Received: by vbbfc21 with SMTP id fc21so2862117vbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2011 10:47:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ECA8908.7070304@broadcom.com>
References: <CADrAYBnwWEaigcgQYYk6V3VEuEYyrmzJQXegKVk6TgOTPh5N8A@mail.gmail.com>
	<4ECA8908.7070304@broadcom.com>
Date: Mon, 21 Nov 2011 19:47:25 +0100
Message-ID: <CADrAYBnaL67Vo7i8yKwVoJwyRy+3tmeCRh0Cb6ok83F1d=29UQ@mail.gmail.com> (sfid-20111121_194729_862931_9C3C1A50)
Subject: Re: brcm80211 (with bcm4329-chip)
From: =?ISO-8859-1?Q?Thomas_Lang=E5s?= <thomas.langas@fxitech.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 21, 2011 at 6:23 PM, Arend van Spriel <arend@broadcom.com> wrote:
> Could you provide some information on the board you are using. Type of
> processor, kernel version, and anything else you can/want to share. In
> /sys/bus/sdio/devices/ you may find the location of the bcm4329.


Kernel version: 3.2.0-rc1 (from linux-samsung tree)
Processor:   Samsung Exynos 4210

* uSD-reader is on mmc 0
* bcm4329 is on mmc 2

Any more details you want to know, please feel free to ask.

Regards,
Thomas

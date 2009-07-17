Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:65051 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933375AbZGQArI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 20:47:08 -0400
Received: by gxk9 with SMTP id 9so925236gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 17:47:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9f53b4330907161718ydbac090k2afc7a749fc9f6f2@mail.gmail.com>
References: <9f53b4330907161718ydbac090k2afc7a749fc9f6f2@mail.gmail.com>
Date: Thu, 16 Jul 2009 20:47:07 -0400
Message-ID: <b6c5339f0907161747l1ff16667k4942cf1f2776d654@mail.gmail.com>
Subject: Re: SDIO Stack and Device Support
From: Bob Copeland <me@bobcopeland.com>
To: Robert Emanuele <rob@emanuele.us>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 16, 2009 at 8:18 PM, Robert Emanuele<rob@emanuele.us> wrote:
> Greetings all,

Hi!  (Added linux-wireless to cc)

> I'm evaluating the potential of getting a Wireless SDIO card to work
> with the 2.6 kernel.  So far all I see in the kernel is support for an
> SDIO UART.  There is a patch on sourceforge for an SDIO stack and
> drivers from Atheros but that is for 2.6.18.  Is there current support
> for other SDIO wireless devices in the kernel?

There is SDIO support for libertas already, and a driver for TI 1251/1271
is in the works.  Wireless drivers will be under drivers/net/wireless/
regardless of bus type.

-- 
Bob Copeland %% www.bobcopeland.com

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35364 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1KUXub (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 18:50:31 -0500
Received: by vbbfc21 with SMTP id fc21so3144666vbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2011 15:50:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F34EB345A846E42B8D432EA578382CC154E402FB4@SJEXCHCCR01.corp.ad.broadcom.com>
References: <CADrAYBnwWEaigcgQYYk6V3VEuEYyrmzJQXegKVk6TgOTPh5N8A@mail.gmail.com>
	<4ECA8908.7070304@broadcom.com>
	<4ECA98DB.4030608@broadcom.com>
	<CADrAYBk7_fsVJUAYNqEZpdBPKOTGUai_UhPT9LMHaEyY+Zm24w@mail.gmail.com>
	<4ECAAD6C.4080103@broadcom.com>
	<CADrAYBndEsNz5nypirSxQPObpSV5BWARWOQzwmBTmzg+tgUbBA@mail.gmail.com>
	<CADrAYB=wDwrzCFEi4-PFepLiLMbPLAGxoaNGtXBaPZPR1onokA@mail.gmail.com>
	<4ECAC99B.8090507@broadcom.com>
	<CADrAYBmhBWVDC=K+F-NU6WkUv-M=WddWvU1pe9AXABEinUBGvQ@mail.gmail.com>
	<4ECAD52A.6050509@broadcom.com>
	<CADrAYBntm4GuhcZaErKimv4Z4Nt+Z6=67qdwi7eomZpTOoQsnQ@mail.gmail.com>
	<4F34EB345A846E42B8D432EA578382CC154E402FB4@SJEXCHCCR01.corp.ad.broadcom.com>
Date: Tue, 22 Nov 2011 00:50:30 +0100
Message-ID: <CADrAYBmD+OzXOLyunz6guyYzwn-mXuHtEaX-7cAVy7QmWp603A@mail.gmail.com> (sfid-20111122_005043_192161_1FF0D37C)
Subject: Re: brcm80211 (with bcm4329-chip)
From: =?ISO-8859-1?Q?Thomas_Lang=E5s?= <thomas.langas@fxitech.com>
To: Howard Harte <hharte@broadcom.com>
Cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 22, 2011 at 12:42 AM, Howard Harte <hharte@broadcom.com> wrote:
> Hello Thomas,
>
> The max clock speed supported by 4329 is 50MHz.

According to the driver (mmc-driver, that is) it's running at 50MHz.

I'll try to see if I can lower it to 25MHz, if you think that could
solve any problems.


Regards,
Thomas

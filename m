Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35590 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752548AbdEQNVo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 May 2017 09:21:44 -0400
Date: Wed, 17 May 2017 15:21:31 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Pavel Machek <pavel@ucw.cz>, Daniel Wagner <wagi@monom.org>,
        Tom Gundersen <teg@jklm.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Gnedt <david.gnedt@davizone.at>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sre@kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Takashi Iwai <tiwai@suse.de>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Grazvydas Ignotas <notasas@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        =?utf-8?Q?Micha=C5=82?= Kazior <kazikcz@gmail.com>
Subject: Re: [PATCH 2/6] wl1251: Use request_firmware_prefer_user() for
 loading NVS calibration data
Message-ID: <20170517132131.GH10015@pali> (sfid-20170517_152221_433636_A5E242DE)
References: <0fd90416-f33c-a6be-14fd-5e964583e9cb@broadcom.com>
 <20170515231339.GF17314@wotan.suse.de>
 <1495022766.2442.1.camel@sipsolutions.net>
 <20170517125335.GG10015@pali>
 <1495026290.2442.6.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1495026290.2442.6.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 17 May 2017 15:04:50 Johannes Berg wrote:
> On Wed, 2017-05-17 at 14:53 +0200, Pali Rohár wrote:
> 
> > > In fact, why should the *driver* care either? IOW - why should
> > > "request_firmware_prefer_user()" even exist?
> > 
> > There are default/example NVS data, which are stored in /lib/firmware
> > and installed by linux-firmware package.
> [...]
> 
> Oh, so you're saying you want this to invert the order ... Ok, that
> makes some sense.

Yes! I thought that this fact can be understood from commit message. If
not, I can change it, but provide how to improve it.

-- 
Pali Rohár
pali.rohar@gmail.com

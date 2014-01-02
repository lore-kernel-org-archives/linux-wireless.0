Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:55035 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaABRMC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jan 2014 12:12:02 -0500
Received: by mail-vc0-f170.google.com with SMTP id la4so7357201vcb.29
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jan 2014 09:12:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOMqctSBd+AvYzKJT+JMPW5h62P2pWKHgV+1wiR0BP7ALarijQ@mail.gmail.com>
References: <52A040CE.5040706@schinagl.nl> <CAFXj5xjJ0DTa0Qo1avLboQF-e3TFv3aEr_jjkuZjinwuTzXykQ@mail.gmail.com>
 <52A09B5B.70800@schinagl.nl> <CAGRGNgWBgWqoPUdHSm2OXGb8r-ca5NX2z4_v0eG6oOMgJRd3HQ@mail.gmail.com>
 <52B17973.1000608@broadcom.com> <52B19F38.7060503@redhat.com>
 <52B1CA51.4010202@broadcom.com> <CAGb2v67cnP0yth0xxBKcaW_T2fF+4nP4r6h9NLqy5FV2x=hO=Q@mail.gmail.com>
 <CAGb2v67mmYnyPeOd4Wwp1zHs7EC_Gr+gEdaaMWeKP5z_Z_SVGA@mail.gmail.com> <CAOMqctSBd+AvYzKJT+JMPW5h62P2pWKHgV+1wiR0BP7ALarijQ@mail.gmail.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Fri, 3 Jan 2014 01:11:41 +0800
Message-ID: <CAGb2v67G8eND2xEP-JwM+B691ETKOM=-3mHSb_OPgs8Dsi6ajQ@mail.gmail.com> (sfid-20140102_181210_608959_A2697E6E)
Subject: Re: [linux-sunxi] Firmware for Bluetooth (and wifi)
To: linux-sunxi <linux-sunxi@googlegroups.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, Jan 3, 2014 at 12:52 AM, Michal Suchanek <hramrach@gmail.com> wrote:
> Hello,
>
> On 19 December 2013 11:12, Chen-Yu Tsai <wens@csie.org> wrote:
[snip]
>> Bluetooth still isn't responding.
>>
>
> Well, bluetooth is supposed to be attached to an UART, not SDIO.
> That's what the datasheets of the chip I found looked like.

Correct. CubieTruck schematics indicate it's connected to UART2.

> Not sure how firmware is supposed to fit in in this case but this
> would not be the first serial BT chip requiring firmware, would it?

Broadcom has a utility called brcm_patchram_plus that loads the
firmware. However I can't get my chip to respond to its first
reset command.


ChenYu

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:43440 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933278AbeFQKIX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Jun 2018 06:08:23 -0400
Received: by mail-qt0-f174.google.com with SMTP id y89-v6so12841274qtd.10
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jun 2018 03:08:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180615172335.VSLI7.207164.root@dnvrco-web09>
References: <20180615165838.QFYTH.206966.root@dnvrco-web09> <20180615172335.VSLI7.207164.root@dnvrco-web09>
From: =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Date: Sun, 17 Jun 2018 12:08:22 +0200
Message-ID: <CABvG-CWroH_u35=PbkWaL6YxB4DNX2vhcjAAwPq=bRQoKWWQDA@mail.gmail.com> (sfid-20180617_120826_953167_514B5EAB)
Subject: Re: Atheros AR9462 - 5Ghz not working
To: mgreger@cinci.rr.com
Cc: Janusz Dziedzic <janusz.dziedzic@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        sedat.dilek@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 June 2018 at 19:23,  <mgreger@cinci.rr.com> wrote:
> ---- mgreger@cinci.rr.com wrote:
>> ---- "Micha=C5=82 Kazior" <kazikcz@gmail.com> wrote:
>> > Your noise floor readout in survey dump is terribly bad for 5GHz. It
>> > ain't stellar for 2.4GHz either but within reason nonetheless.
>> >
>> > Did you try using the card in a different device? I wonder if the
>> > device you're trying to use it in has some sort of internal noise on
>> > those frequencies and/or ath9k's ANI isn't able to deal with it.
>> >
>> >
>> > Micha=C5=82
>> >
>> > On 15 June 2018 at 15:31,  <mgreger@cinci.rr.com> wrote:
>>
>> I did.
>> I took it out of the Penguin-Z notebook and put it in a Dell XPS15 9560 =
running Windows 10. Only 2.4Ghz networks were visible from there as well. N=
ot exactly apples-to-apples, but consistent results.

This reduces likeliness this is tied to a os/driver issue. Maybe
calibration data on the device eeprom is broken? Or maybe it's a
hardware defect?


> Could it be antenna related (in multiple devices)?

Antennas can be designed to work better on certain frequency ranges. I
wouldn't expect such a dramatic effect though.


> On wikidevi.com I see some M.2 cards listed with an antenna connector of =
U.FL and others with MHF4. I can't find anything describing the difference,=
 if any. The connectors seemed to fit OK. Also, what's the deal with 'main'=
 and 'aux' antenna connectors? I've seen people suggest swapping them has h=
elped in some cases with poor signal, while others insist that it makes no =
difference. I have not tried swapping the connectors.

I think it's not a connector problem because 2.4GHz scan results
report reasonable signal strength for found APs (-60dBm). My
experience is that if you use a wrong (but seemingly fitting)
connector you'd get near 0 results or below -90dBm across the board.


Micha=C5=82

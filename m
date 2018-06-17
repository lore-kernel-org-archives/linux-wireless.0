Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:41631 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751340AbeFQVbl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Jun 2018 17:31:41 -0400
Received: by mail-oi0-f54.google.com with SMTP id a141-v6so13146103oii.8
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jun 2018 14:31:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180617145210.BYHHS.193136.root@dnvrco-web12>
References: <CABvG-CWroH_u35=PbkWaL6YxB4DNX2vhcjAAwPq=bRQoKWWQDA@mail.gmail.com>
 <20180617145210.BYHHS.193136.root@dnvrco-web12>
From: Tom Psyborg <pozega.tomislav@gmail.com>
Date: Sun, 17 Jun 2018 23:31:39 +0200
Message-ID: <CAKR_QV+pfv3sWCQzgFKB8k1MEad2NUWv==9+0z9T6radmDzQGw@mail.gmail.com> (sfid-20180617_233316_001655_D386B1AE)
Subject: Re: Atheros AR9462 - 5Ghz not working
To: mgreger@cinci.rr.com
Cc: =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>,
        Janusz Dziedzic <janusz.dziedzic@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        sedat.dilek@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

Your log only show attemps on ch 2447, Can you try connecting to 5GHz
AP? Connect to Hidden Wireless Network option at the bottom of the
nm-applet? Running airodump in monitor mode to see if it captures
anything? Maybe your laptop's antennas were designed for 2.4G card
only but this just dumb guessing...

On 17/06/2018, mgreger@cinci.rr.com <mgreger@cinci.rr.com> wrote:
>
> ---- "Micha=C5=82 Kazior" <kazikcz@gmail.com> wrote:
>> On 15 June 2018 at 19:23,  <mgreger@cinci.rr.com> wrote:
>> > ---- mgreger@cinci.rr.com wrote:
>> >> ---- "Micha=C5=82 Kazior" <kazikcz@gmail.com> wrote:
>> >> > Your noise floor readout in survey dump is terribly bad for 5GHz. I=
t
>> >> > ain't stellar for 2.4GHz either but within reason nonetheless.
>> >> >
>> >> > Did you try using the card in a different device? I wonder if the
>> >> > device you're trying to use it in has some sort of internal noise o=
n
>> >> > those frequencies and/or ath9k's ANI isn't able to deal with it.
>> >> >
>> >> >
>> >> > Micha=C5=82
>> >> >
>> >> > On 15 June 2018 at 15:31,  <mgreger@cinci.rr.com> wrote:
>> >>
>> >> I did.
>> >> I took it out of the Penguin-Z notebook and put it in a Dell XPS15 95=
60
>> >> running Windows 10. Only 2.4Ghz networks were visible from there as
>> >> well. Not exactly apples-to-apples, but consistent results.
>>
>> This reduces likeliness this is tied to a os/driver issue. Maybe
>> calibration data on the device eeprom is broken? Or maybe it's a
>> hardware defect?
>
>
>
>
> I have three of these cards all with the same problem, so if it's a hardw=
are
> defect then it's pretty much game over and these cards are all useless.
> Forgive my ignorance, but is there any way to check/fix calibration data?
>
>
>
>
>>
>>
>> > Could it be antenna related (in multiple devices)?
>>
>> Antennas can be designed to work better on certain frequency ranges. I
>> wouldn't expect such a dramatic effect though.
>>
>>
>> > On wikidevi.com I see some M.2 cards listed with an antenna connector =
of
>> > U.FL and others with MHF4. I can't find anything describing the
>> > difference, if any. The connectors seemed to fit OK. Also, what's the
>> > deal with 'main' and 'aux' antenna connectors? I've seen people sugges=
t
>> > swapping them has helped in some cases with poor signal, while others
>> > insist that it makes no difference. I have not tried swapping the
>> > connectors.
>>
>> I think it's not a connector problem because 2.4GHz scan results
>> report reasonable signal strength for found APs (-60dBm). My
>> experience is that if you use a wrong (but seemingly fitting)
>> connector you'd get near 0 results or below -90dBm across the board.
>>
>>
>> Micha=C5=82
>
>

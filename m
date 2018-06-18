Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dnvrco-outbound-snat.email.rr.com ([107.14.73.225]:9353 "EHLO
        dnvrco-cmomta02.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752835AbeFRNxa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 09:53:30 -0400
Message-ID: <20180618135329.N2TLO.197792.root@dnvrco-web12> (sfid-20180618_155333_999904_D3F903AA)
Date: Mon, 18 Jun 2018 13:53:29 +0000
From: <mgreger@cinci.rr.com>
To: Tom Psyborg <pozega.tomislav@gmail.com>
Subject: Re: Atheros AR9462 - 5Ghz not working
Cc: Janusz Dziedzic <janusz.dziedzic@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        sedat.dilek@gmail.com,
        =?utf-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
In-Reply-To: <CAKR_QV+pfv3sWCQzgFKB8k1MEad2NUWv==9+0z9T6radmDzQGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


---- Tom Psyborg <pozega.tomislav@gmail.com> wrote: 
> Hi
> 
> Your log only show attemps on ch 2447, Can you try connecting to 5GHz
> AP? Connect to Hidden Wireless Network option at the bottom of the
> nm-applet? Running airodump in monitor mode to see if it captures
> anything? Maybe your laptop's antennas were designed for 2.4G card
> only but this just dumb guessing...
> 

It won't connect to any 5GHz AP.
I don't run network manager or Gnome, in fact X11 is not installed on this machine at all.
I don't think there is such a thing as 2.4GHz vs 5GHz antennas.


> On 17/06/2018, mgreger@cinci.rr.com <mgreger@cinci.rr.com> wrote:
> >
> > ---- "Michał Kazior" <kazikcz@gmail.com> wrote:
> >> On 15 June 2018 at 19:23,  <mgreger@cinci.rr.com> wrote:
> >> > ---- mgreger@cinci.rr.com wrote:
> >> >> ---- "Michał Kazior" <kazikcz@gmail.com> wrote:
> >> >> > Your noise floor readout in survey dump is terribly bad for 5GHz. It
> >> >> > ain't stellar for 2.4GHz either but within reason nonetheless.
> >> >> >
> >> >> > Did you try using the card in a different device? I wonder if the
> >> >> > device you're trying to use it in has some sort of internal noise on
> >> >> > those frequencies and/or ath9k's ANI isn't able to deal with it.
> >> >> >
> >> >> >
> >> >> > Michał
> >> >> >
> >> >> > On 15 June 2018 at 15:31,  <mgreger@cinci.rr.com> wrote:
> >> >>
> >> >> I did.
> >> >> I took it out of the Penguin-Z notebook and put it in a Dell XPS15 9560
> >> >> running Windows 10. Only 2.4Ghz networks were visible from there as
> >> >> well. Not exactly apples-to-apples, but consistent results.
> >>
> >> This reduces likeliness this is tied to a os/driver issue. Maybe
> >> calibration data on the device eeprom is broken? Or maybe it's a
> >> hardware defect?
> >
> >
> >
> >
> > I have three of these cards all with the same problem, so if it's a hardware
> > defect then it's pretty much game over and these cards are all useless.
> > Forgive my ignorance, but is there any way to check/fix calibration data?
> >
> >
> >
> >
> >>
> >>
> >> > Could it be antenna related (in multiple devices)?
> >>
> >> Antennas can be designed to work better on certain frequency ranges. I
> >> wouldn't expect such a dramatic effect though.
> >>
> >>
> >> > On wikidevi.com I see some M.2 cards listed with an antenna connector of
> >> > U.FL and others with MHF4. I can't find anything describing the
> >> > difference, if any. The connectors seemed to fit OK. Also, what's the
> >> > deal with 'main' and 'aux' antenna connectors? I've seen people suggest
> >> > swapping them has helped in some cases with poor signal, while others
> >> > insist that it makes no difference. I have not tried swapping the
> >> > connectors.
> >>
> >> I think it's not a connector problem because 2.4GHz scan results
> >> report reasonable signal strength for found APs (-60dBm). My
> >> experience is that if you use a wrong (but seemingly fitting)
> >> connector you'd get near 0 results or below -90dBm across the board.
> >>
> >>
> >> Michał
> >
> >

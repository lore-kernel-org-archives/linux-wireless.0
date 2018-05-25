Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dnvrco-outbound-snat.email.rr.com ([107.14.73.230]:7733 "EHLO
        dnvrco-cmomta03.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752413AbeEYNGq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 09:06:46 -0400
Message-ID: <20180525130644.XJCYB.49285.root@dnvrco-web25> (sfid-20180525_150649_902118_44AC1614)
Date: Fri, 25 May 2018 13:06:44 +0000
From: <mgreger@cinci.rr.com>
To: Reinoud Koornstra <reinoudkoornstra@gmail.com>
Subject: Re: Can no one help me?
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAAA5faH+tU8-xhaQjfO4S2yKN_b=HTVfAxi8QaN7QObAdrV-pA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the reply.

My first message to the list did have more information. I've tried the latest mainline kernel and also the default kernel for Debian stable and multiple other distros (Ubuntu, Arch, etc). The cards (I have several of the same model) are AR9462 in an M.2 NGFF format using the ath9k driver with 0x64 world roaming regdomain in EEPROM and US regdomain set via crda and iw claims the card supports both bands. No error messages to speak of, just 5GHz networks simply don't show up in scans and can't be associated with despite there being nearly a dozen different 5Ghz networks within range. The card acts like the entire 5Ghz band is NO_IR restricted (incoming packet statistics for 5Ghz via 'iw survey dump' do increment, but tx values are always zero. 2.4Ghz works fine. A custom kernel enabling beacon hints made no difference.

I've now come to believe it's not software, but the cards themselves as OS/kernel/hardware seems to make no difference. I even installed them in a different brand/model laptop running MS Windows and got the same results.

Since it was incredibly difficult to find an ath9k supported dual band card in M.2 format with a A-key slot needed by my laptop, I'm thinking now maybe the cards are simply faulty or designed incorrectly. These were bought via aliexpress.com and advertised as 5Ghz capable, but I've been unable to locate them anywhere else...all other sources seem to only carry AR9462 as Mini-PCIE, and not M.2

Anyway, I've given up on them. If anyone happens to know of an M.2 A-keyed dual band card supported by an open driver (preferrably no or open firmware too) I'd really appreciate it, but I'm not holding my breath.

Again, thanks anyway.


---- Reinoud Koornstra <reinoudkoornstra@gmail.com> wrote: 
> What kernels have you tried? What messages do you get? Is the card not
> supported? Crash? It's always good to share more info on what you're
> experienced.
> 
> On Wed, May 23, 2018, 5:38 PM <mgreger@cinci.rr.com> wrote:
> 
> > I realize this is a development mailinglist and not a support forum, but
> > I'm really at the end of my rope here.
> >
> > If someone can get this working, I'll buy them a nice lunch if they're
> > ever near Cincinnati.
> >
> > I've tried booting alternative distros to see if it is a software problem,
> > but no distro I've tried will work. I've even replaced the AR9462 card with
> > another one, thinking maybe the hardware was bad...but no change.
> >
> > Surely someone here has a clue as to what's going on?
> >
> > Many thanks in advance for any help.
> >

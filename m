Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dnvrco-outbound-snat.email.rr.com ([107.14.73.225]:63515 "EHLO
        dnvrco-cmomta02.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934312AbeFORXg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Jun 2018 13:23:36 -0400
Message-ID: <20180615172335.VSLI7.207164.root@dnvrco-web09> (sfid-20180615_192340_426415_89839377)
Date: Fri, 15 Jun 2018 17:23:35 +0000
From: <mgreger@cinci.rr.com>
To: =?utf-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>,
        mgreger@cinci.rr.com
Subject: Re: Atheros AR9462 - 5Ghz not working
Cc: Janusz Dziedzic <janusz.dziedzic@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        sedat.dilek@gmail.com
In-Reply-To: <20180615165838.QFYTH.206966.root@dnvrco-web09>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


---- mgreger@cinci.rr.com wrote: 
> 
> ---- "Michał Kazior" <kazikcz@gmail.com> wrote: 
> > Your noise floor readout in survey dump is terribly bad for 5GHz. It
> > ain't stellar for 2.4GHz either but within reason nonetheless.
> > 
> > Did you try using the card in a different device? I wonder if the
> > device you're trying to use it in has some sort of internal noise on
> > those frequencies and/or ath9k's ANI isn't able to deal with it.
> > 
> > 
> > Michał
> > 
> > On 15 June 2018 at 15:31,  <mgreger@cinci.rr.com> wrote:
> 
> 
> I did.
> I took it out of the Penguin-Z notebook and put it in a Dell XPS15 9560 running Windows 10. Only 2.4Ghz networks were visible from there as well. Not exactly apples-to-apples, but consistent results.


Could it be antenna related (in multiple devices)?

On wikidevi.com I see some M.2 cards listed with an antenna connector of U.FL and others with MHF4. I can't find anything describing the difference, if any. The connectors seemed to fit OK. Also, what's the deal with 'main' and 'aux' antenna connectors? I've seen people suggest swapping them has helped in some cases with poor signal, while others insist that it makes no difference. I have not tried swapping the connectors.

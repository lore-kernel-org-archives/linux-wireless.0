Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:43260 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753100AbeDLPwD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 11:52:03 -0400
Message-ID: <1517ecac1d85eb746367d9db436beca2d8f47835.camel@redhat.com> (sfid-20180412_175207_026634_6F21B50F)
Subject: Re: second wifi card enforce CN reg dom
From: Dan Williams <dcbw@redhat.com>
To: Steve deRosier <derosier@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: solsTiCe d'Hiver <solstice.dhiver@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 12 Apr 2018 10:52:01 -0500
In-Reply-To: <CALLGbRLJLxu92S2bYFOk9oJCLanES4Fu6e-9bh9oAupEC0Uw5w@mail.gmail.com>
References: <CAE4vF2fCTEmEX8i+XVpvTJ1sRYDHDLr+fYFAM2PzTQTqkCoXVQ@mail.gmail.com>
         <CAE4vF2f2oXEvOJWDXPjmiWZTC=HOq5+xE_R64-_VvH6zc-Vw+A@mail.gmail.com>
         <5ACF0F5A.3090301@broadcom.com>
         <CAE4vF2ftgMPhKEUHr2rPaobM9Dtuc-B9rtbF5tWavvrwUXA7Ag@mail.gmail.com>
         <5ACF3A28.4060303@broadcom.com>
         <CALLGbRLJLxu92S2bYFOk9oJCLanES4Fu6e-9bh9oAupEC0Uw5w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-04-12 at 08:18 -0700, Steve deRosier wrote:
> On Thu, Apr 12, 2018 at 3:51 AM, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
> > On 4/12/2018 10:42 AM, solsTiCe d'Hiver wrote:
> > > 
> > > Hi.
> > > 
> > > This is beyond my comprehension that you could assert this is a
> > > non issue.
> > 
> > 
> > Well. I am just saying that it is by design. There is no way for
> > the
> > regulatory code to determine where you and your hardware actually
> > reside so
> > instead it takes a conservative approach.
> > 
> 
> To say it another way: mixing regulatory domains on your host system
> should result in a _smaller_ set of channels - ie only those channels
> at the intersection of the two.
> 
> And another wrinkle to consider - one of the 802.11 amendments (can't
> remember which one) actually causes the radio to listen to the 

802.11d I believe, from the early 2000s.

Dan

> beacons
> around it, determine what the local regulatory domain is based on the
> beacons it hears, and then lock to that regulatory domain. It's
> possible for that information to be propagated up to the card's host
> and the regulatory domain then would affect both cards. That's how
> it's supposed to work, though I don't factually know Linux does this
> in all cases.  Could it be you're somewhere where CN is the local
> regulatory domain and the TL-WN722N has this feature?
> 
> In any case, as Arend points out, despite the hand-wringing that
> regulatory domains cause users trying to do something particular,
> between certain rules and regulations and certain manufacturers bad
> interpretations and implementations around it, there's little that
> can
> be done about it. Fact is, your radio must comply to whatever
> regulatory domain you are in, otherwise it's breaking the rules. And
> people breaking the regulatory rules is part of what's gotten
> governments to pass even worse (for us OSS guys) laws that tighten
> those rules down further.
> 
> You asked who to contact. Its not the LKML - it's your relevant
> government body. And certain manufacturers who improperly interpret
> said rules because it's easier for them.
> 
> - Steve
> 
> --
> Steve deRosier
> Cal-Sierra Consulting LLC
> https://www.cal-sierra.com/

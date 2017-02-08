Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44315 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751563AbdBHW5F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 17:57:05 -0500
Date: Wed, 8 Feb 2017 15:56:51 -0700
From: Mark Greer <mgreer@animalcreek.com>
To: Geoff Lansberry <geoff@kuvee.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Justin Bronder <justin@kuvee.com>,
        linux-nfc <linux-nfc@lists.01.org>
Subject: Re: [Patch] NFC: trf7970a:
Message-ID: <20170208225651.GB26286@animalcreek.com> (sfid-20170208_235729_506726_D92CDFFC)
References: <20161214155743.GA22282@animalcreek.com>
 <CAO7Z3WKqhS5Q6qAaDs8364KP5-7ma=b_ic2B10=njngMmp5noQ@mail.gmail.com>
 <20161214171010.GA29321@animalcreek.com>
 <CAO7Z3WLpp0YVxXxo6M11PMPu+5OaA1fRhNQNoPJ-b4LRCPrLAg@mail.gmail.com>
 <20161214223123.GA10281@animalcreek.com>
 <20161216045210.GA29196@animalcreek.com>
 <20161216203538.GA12608@animalcreek.com>
 <CAO7Z3W+grhLnP05bPShheuvSet08CoYhFStDpDVgztf=Wz42Fw@mail.gmail.com>
 <20161219030733.GA14962@animalcreek.com>
 <20170208225339.GA26286@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170208225339.GA26286@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just realized that the linux-nfc is not CC'd so adding it.

On Wed, Feb 08, 2017 at 03:53:39PM -0700, Mark Greer wrote:
> On Sun, Dec 18, 2016 at 08:07:33PM -0700, Mark Greer wrote:
> > On Sat, Dec 17, 2016 at 04:19:04PM -0500, Geoff Lansberry wrote:
> > > Mark,   from our consultant:
> > > 
> > > It isn't important whether the flood script is successful in writing
> > > or not. The point of it is to force a segfault by making many
> > > requests. It needs to run for several hundred iterations (successful
> > > or not) in order to generate the segfault.
> > 
> > So neard crashes even when the write fails??  Okay, I'll let it run for
> > a while tomorrow (Monday).
> 
> [Okay, so not exactly "tomorrow" but I did get back to this.]
> 
> Geoff, a few things:
> 
> 1) Any update on these issues?
> 
> 2) Do you have all of the NFC-related patches from the nfc-next master
> branch?  In particular, do you have all of Thierry's patches to
> net/nfc/digial_*.c dated around June-July 2016?  Without those patches,
> I see a panic; with them, I don't.
> 
> 3) Assuming you have all of those patches, please revert the one with the
> summary line of, "NFC: digital: Set the command pending flag", and tell me
> if that stops the "Bogus state" messages.  I don't know which repo/branch
> you're using so I can't provide a commit id.
> 
> Thanks,
> 
> Mark
> --

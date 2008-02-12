Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:6395 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523AbYBLIpq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 03:45:46 -0500
Received: by nf-out-0910.google.com with SMTP id g13so1359795nfb.21
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2008 00:45:40 -0800 (PST)
Message-ID: <57314e840802120045h6e6960d8jde5657da8aff0e3e@mail.gmail.com> (sfid-20080212_084600_245746_2698F8AB)
Date: Tue, 12 Feb 2008 10:45:40 +0200
From: "Budhee Jamaich" <budheej@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: madwifi is not fully open source
Cc: linux-wireless@vger.kernel.org, "Kalle Valo" <kalle.valo@nokia.com>
In-Reply-To: <1202770112.6824.35.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <57314e840802111427i7e8d00capbe430727faff78a1@mail.gmail.com>
	 <1202770112.6824.35.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

First - thank you for the detailed response!

I have some further questions:

On Feb 12, 2008 12:48 AM, Dan Williams <dcbw@redhat.com> wrote:
> On Tue, 2008-02-12 at 00:27 +0200, Budhee Jamaich wrote:
> > What should a new vendor, planning to write a driver, do ? Open Source
> > everything, and expect legal issues, or release RF code as binary-only ?
>
> Talk to your lawyers.  You do not necessarily have legal issues if you
> open the RF regulatory code,

>From reading SFLC's and LWN's analysis of the situation (Thanks Kalle for
pointing me to it) I get the opposite impression. Seems like a vendor will
have to "demonstrate sufficient robustness with a fully free-software
implementation",
and that it "could still get certification. But it would not be easy".
So even if a vendor is willng to completely Open Source it's code,
having FCC troubles
is a serious problem.


>
> 2) Keep your RF regulatory code open and hook it into the mac80211
> regulatory framework like most other open drivers are doing.  Again,
> consult your lawyers on whether or not they feel this is an acceptable
> solution.  Your driver can be accepted into the upstream kernel, hordes
> of developers will improve your driver for you, and everyone is happy.

Is there any vendor who walked this path ? complete Open Source RF code ?
If yes, has it's chip got FCC certified ?
>
> 3) Put your RF regulatory code into the _firmware_ of your device (this
> is what Intel has done with 3945 and 4965 parts).  This is very
> acceptable, but still be sure to consult your lawyers.  Your driver can
> be accepted into the upstream kernel, hordes of developers will improve
> your driver for you, and everyone is happy.

Seems like a good option, but only if the design of the chip support
it (CCIIW pls).
If this idea is not supported in the hardware, we are left with the other
two options, both of each are not optimal.

So it seems like your three options translate to:
1. full Open Source: happy Open Source developers (+), can't sell device (big -)
2. firmware RF code: happy FOSS ppl (+), can sell device (+), depends on
chip design...(not always possible)
3. RF blob: mad FOSS ppl (- but can live with if no other option), can
sell device(+)

> Hope this helps, feel free to ask further questions if some things
> aren't clear enough.

Greatly helps, thanks again,
Budhee.

>
> Dan
>
>

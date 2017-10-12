Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52934 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751542AbdJLTCe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 15:02:34 -0400
Message-ID: <1507834948.5497.9.camel@coelho.fi> (sfid-20171012_210304_843075_72AF8BE6)
From: Luca Coelho <luca@coelho.fi>
To: Mark Brown <broonie@kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Wireless <linux-wireless@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 12 Oct 2017 22:02:28 +0300
In-Reply-To: <20171012185944.bip4cdk7bd4d6mpc@sirena.co.uk>
References: <20171012172512.tlsdjhppfz2hu4vr@sirena.co.uk>
         <1507832196.5497.1.camel@intel.com>
         <20171012182114.fdeiv67ebx7c63te@sirena.co.uk>
         <1507832866.5497.2.camel@intel.com>
         <20171012183505.oo77lgdbmqjevsuo@sirena.co.uk>
         <1507834251.5497.7.camel@coelho.fi>
         <20171012185944.bip4cdk7bd4d6mpc@sirena.co.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: linux-next: manual merge of the wireless-drivers-next tree with
 the wireless-drivers tree
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-10-12 at 19:59 +0100, Mark Brown wrote:
> On Thu, Oct 12, 2017 at 09:50:51PM +0300, Luca Coelho wrote:
> > On Thu, 2017-10-12 at 19:35 +0100, Mark Brown wrote:
> > > With trees like this that don't coordinate with their fixes
> > > branch
> > > there
> > > are frequently multiple conflicts introduced so I generally
> > > report
> > > things file by file without even looking at the new ones.
> > Sorry for the trouble.  But how do you suggest that we "coordinate
> > our
> > fixes branch"? Merge fixes into the main tree?
> 
> That'd be easiest for me!  It's not of necessity a problem if the
> conflicts are easy enough to resolve if you just let things get
> merged
> in -next, it's just more an observation that that's a thing that
> happens
> and that this is how I cope with it.  Stephen may do things a bit
> differently.

Cool, I'll discuss this with Kalle and make sure I note these potential
conflicts early enough so everyone is aware when they're coming.

Thanks for taking over while Stephen is away! I really appreciate it,
since linux-next is a very important part of our process. :)

--
Luca.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52916 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751067AbdJLSu5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 14:50:57 -0400
Message-ID: <1507834251.5497.7.camel@coelho.fi> (sfid-20171012_205143_535715_054FE6DA)
From: Luca Coelho <luca@coelho.fi>
To: Mark Brown <broonie@kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Wireless <linux-wireless@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 12 Oct 2017 21:50:51 +0300
In-Reply-To: <20171012183505.oo77lgdbmqjevsuo@sirena.co.uk>
References: <20171012172512.tlsdjhppfz2hu4vr@sirena.co.uk>
         <1507832196.5497.1.camel@intel.com>
         <20171012182114.fdeiv67ebx7c63te@sirena.co.uk>
         <1507832866.5497.2.camel@intel.com>
         <20171012183505.oo77lgdbmqjevsuo@sirena.co.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: linux-next: manual merge of the wireless-drivers-next tree with
 the wireless-drivers tree
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-10-12 at 19:35 +0100, Mark Brown wrote:
> On Thu, Oct 12, 2017 at 09:27:46PM +0300, Luciano Coelho wrote:
> > On Thu, 2017-10-12 at 19:21 +0100, Mark Brown wrote:
> > > I may have confused the trees when I was pasting things in, the
> > > commits
> > > are filled in by hand.
> > 
> > Ah, okay.  But still, if the same patches conflicted twice, why
> > wasn't
> > there only one occurrence with both conflicts at once?
> 
> With trees like this that don't coordinate with their fixes branch
> there
> are frequently multiple conflicts introduced so I generally report
> things file by file without even looking at the new ones.

Sorry for the trouble.  But how do you suggest that we "coordinate our
fixes branch"? Merge fixes into the main tree?

--
Luca.

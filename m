Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:32843 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757225AbdCUP7W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Mar 2017 11:59:22 -0400
Received: by mail-pf0-f181.google.com with SMTP id o190so2221pfo.0
        for <linux-wireless@vger.kernel.org>; Tue, 21 Mar 2017 08:59:21 -0700 (PDT)
Date: Tue, 21 Mar 2017 08:59:18 -0700
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rajat Jain <rajatja@google.com>
Subject: Re: [4/4] mwifiex: pcie: de-duplicate buffer allocation code
Message-ID: <20170321155916.GA95754@google.com> (sfid-20170321_170024_288206_A103497C)
References: <20170311013924.73348-5-briannorris@chromium.org>
 <20170320170835.5ED1C609C6@smtp.codeaurora.org>
 <20170320200550.GA12143@google.com>
 <874lym7roy.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <874lym7roy.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 21, 2017 at 02:14:05PM +0200, Kalle Valo wrote:
> Brian Norris <briannorris@chromium.org> writes:
> > On Mon, Mar 20, 2017 at 05:08:35PM +0000, Kalle Valo wrote:
> >> Failed to apply:
> >> 
> >> fatal: sha1 information is lacking or useless
> >> (drivers/net/wireless/marvell/mwifiex/pcie.c).
> >> error: could not build fake ancestor
> >> Applying: mwifiex: pcie: de-duplicate buffer allocation code
> >> Patch failed at 0001 mwifiex: pcie: de-duplicate buffer allocation code
> >> The copy of the patch that failed is found in: .git/rebase-apply/patch
> >> 
> >> Patch set to Changes Requested.
> >
> > This applies fine to your wireless-drivers/master branch for me, where
> > patches 1-3 were applied. Are you applying this to
> > wireless-drivers-next? It's quite understandable that patch 4 wouldn't
> > apply there, as you've stripped out the previous patches...
> 
> I (wrongly) understood that patches 1-3 are for 4.11 and patch 4 is for
> 4.12, don't remember anymore how I got that impression. But I don't

Well, you're not exactly wrong. I mentioned in the cover letter that the
first 3 are bugfixes (probably for 4.11) and the 4th is not.

> think a cleanup patch like this is justified for 4.11 so I'm not
> comfortable applying this to wireless-drivers (which should only contain
> fixes to important bugs or regressions).

Right.

> What I could do is to wait for the patches 1-3 trickle down to w-d-next
> and then apply this patch. It usually takes few weeks, but with bad luck
> it might happen only after the merge window. Would that work?

Yeah, I figured something like that would happen. Seems fine to me.

Brian

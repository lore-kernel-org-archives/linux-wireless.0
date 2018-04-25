Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:5265 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750921AbeDYFbE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 01:31:04 -0400
Message-ID: <ef221a8abfecadfcbc637a0731150e648c85315f.camel@intel.com> (sfid-20180425_073119_232868_1E695456)
Subject: Re: linux-next: Signed-off-by missing for commit in the
 wireless-drivers-next tree
From: Luciano Coelho <luciano.coelho@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Sara Sharon <sara.sharon@intel.com>
Date: Wed, 25 Apr 2018 08:31:00 +0300
In-Reply-To: <20180425105619.09f58e39@canb.auug.org.au>
References: <20180425105619.09f58e39@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, 2018-04-25 at 10:56 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Commit
> 
>   84226ca1c5d3 ("iwlwifi: mvm: support offload of AMSDU rate
> control")
> 
> is missing a Signed-off-by from its author.

I checked this and it should be fine.  The author is actually wrong in
the commit.  Sara is the actual author and we have her S-o-B in the
commit.

I have no idea how Gregory became the author in that commit, though.  I
checked exactly how I committed it and checked the author in our
internal tree.  It's all fine, but for some really weird reason that I
can't figure out, Gregory became the author of the commit when I
applied that patch.  The AuthorDate is also wrong.  I checked my bash
history to see how I applied the patch and everything looks normal...
*confused*


--
Cheers,
Luca.

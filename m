Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:52075 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751523AbdF1WFm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 18:05:42 -0400
Date: Thu, 29 Jun 2017 08:05:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux Next Mailing List <linux-next@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Linux NFC List <linux-nfc@lists.01.org>
Subject: Re: Adding nfc-next to linux-next
Message-ID: <20170629080537.2970e966@canb.auug.org.au> (sfid-20170629_000557_177766_30145252)
In-Reply-To: <20170628072531.GM21214@zurbaran.ger.intel.com>
References: <20170628072531.GM21214@zurbaran.ger.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel,

On Wed, 28 Jun 2017 09:25:31 +0200 Samuel Ortiz <sameo@linux.intel.com> wrote:
>
> Could you please add the nfc-next tree to linux-next?
> 
> It's here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git/
> 
> and the branch is the master one.

Added from today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgement of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window. 

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
        Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and 
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

-- 
Cheers,
Stephen Rothwell 
sfr@canb.auug.org.au

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41759 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaDNSaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 14:30:17 -0400
Date: Mon, 14 Apr 2014 14:22:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2014-04-13
Message-ID: <20140414182242.GF27324@tuxdriver.com> (sfid-20140414_203031_780713_A012E66F)
References: <534A8A49.2030100@gmail.com>
 <534A96DB.90505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <534A96DB.90505@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 13, 2014 at 04:53:31PM +0300, Emmanuel Grumbach wrote:
> 
> 
> On 04/13/2014 03:59 PM, Emmanuel Grumbach wrote:
> > Hi John,
> > 
> > This is a first pull request of fixes for 3.15.
> > 
> > I have new device IDs and a new firmware API. These are the trivial ones. The less trivial ones are Johannes's fix that delays the enablement of an interrupt coalescing hardware until after association - this fixes a few connection problems seen in the field. Eyal has a bunch of rate control fixes. I decided to add these for 3.15 because they fix some disconnection and packet loss scenarios which were reported by the field. I also have a fix for a memory leak that happens only with a very new NIC.
> > 
> > I'll be with low connectivity for the coming week and a half, so I want hope you won't have any issues with this pull request. If you do have issues, please let me know, but I am not sure I'll be able to handle the problems immediately.
> > 
> > Thanks!
> > a6bc92803e7f765e02c923cf37c8e280e729642aa6bc92803e7f765e02c923cf37c8e280e729642aa6bc92803e7f765e02c923cf37c8e280e729642a
> > The following changes since commit 67b3bd4e65f0854aca70e0134d59b1daede49504:
> > 
> >   brcmfmac: fallback to mimo_bw_cap for older firmwares (2014-03-20 11:55:41 -0400)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git for-john
> > 
> > for you to fetch changes up to f59913dfbb8ce07d7fb527f67b26791aa849aa1c:
> > 
> 
> I had a typo in the stable address in one of the patches - new HEAD: a6bc92803e7f765e02c923cf37c8e280e729642a

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

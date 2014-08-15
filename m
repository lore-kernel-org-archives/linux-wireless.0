Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34688 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaHOOpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2014 10:45:13 -0400
Date: Fri, 15 Aug 2014 10:30:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@redhat.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless 2014-08-14
Message-ID: <20140815143014.GK4953@tuxdriver.com> (sfid-20140815_164524_059344_EE92AC67)
References: <20140814183253.GF4953@tuxdriver.com>
 <20140814.151809.1355093138463959620.davem@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140814.151809.1355093138463959620.davem@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 14, 2014 at 03:18:09PM -0700, David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Thu, 14 Aug 2014 14:32:53 -0400
> 
> > Please pull this batch of fixes intended for the 3.17 stream...
> > 
> > Arend van Spriel brings two brcmfmac fixes, one which fixes a memory
> > leak and one which corrects some merge damage.
> > 
> > Emmanuel Grumbach fixes Linus's iwlwifi firmware-related log spam.
> > 
> > Rickard Strandqvist does some proper NULL termination after a call
> > to strncpy.
> > 
> > Ronald Wahl corrects a carl9170 problem with sending URBs with the
> > wrong endpoint type (resulting in log spam).
> > 
> > Please let me know if there are problems!
> 
> Pulled, thanks John.
> 
> I'm really happy that you send the iwlwifi regression fix so quickly!

One-liners with a "Tested-by: Linus Torvalds" get a lot of respect... :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

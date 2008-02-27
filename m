Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3246 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273AbYB0QDN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 11:03:13 -0500
Date: Wed, 27 Feb 2008 10:52:57 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, bruno@thinktube.com,
	jirislaby@gmail.com
Subject: Re: [ath5k-devel] [PATCH 6/8] ath5k: Fixes for PCI-E cards
Message-ID: <20080227155257.GC3078@tuxdriver.com> (sfid-20080227_160318_675212_6471C259)
References: <20080224042851.GE4426@makis.domain.invalid> <40f31dec0802232045v2902d76dg8ee1c4a4685862fe@mail.gmail.com> <20080224175933.GA4360@hash.localnet> <40f31dec0802241058h5b37a471s5092dd370a4f2a48@mail.gmail.com> <43e72e890802261923g528f4006ofd665edbba335d99@mail.gmail.com> <40f31dec0802262154k4e768257hb8ad255e2eb1f6a2@mail.gmail.com> <43e72e890802270530j6ca4a6eal832d642a94a49e94@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890802270530j6ca4a6eal832d642a94a49e94@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 27, 2008 at 08:30:18AM -0500, Luis R. Rodriguez wrote:
> On Wed, Feb 27, 2008 at 12:54 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:

> >  What if there is a pci-e card in the future that needs _PCI bit ?
> 
> I don't follow, the member is for struct pci_dev so its either a pci
> or pci-express device. If you mean what if we later have some srev in
> the range that is not pci-e, well then we'd use srevs wouldn't we?
> 
> > I guess for now we can work on with srevs to be safe but it's good to
> >  know of that feature, thanx ;-)
> 
> The point is that if there is already a variable we can use to detect
> if a device is pci-e then we shouldn't introduce any other new ones.

ACK for Luis's point.

-- 
John W. Linville
linville@tuxdriver.com

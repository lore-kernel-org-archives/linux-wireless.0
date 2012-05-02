Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41824 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671Ab2EBSRt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2012 14:17:49 -0400
Date: Wed, 2 May 2012 14:11:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Nathan Hintz <nlhintz@hotmail.com>,
	linux-wireless@vger.kernel.org, hauke@hauke-m.de
Subject: Re: [PATCH v2 0/6] BCMA Cumulative patches from OpenWRT
Message-ID: <20120502181157.GC9285@tuxdriver.com> (sfid-20120502_201753_568350_5CE550AB)
References: <BLU0-SMTP45859B1CA3415BE44C9024CAC240@phx.gbl>
 <4F990DC1.4070305@broadcom.com>
 <87r4vaaezl.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87r4vaaezl.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 26, 2012 at 02:50:54PM +0300, Kalle Valo wrote:
> "Arend van Spriel" <arend@broadcom.com> writes:
> 
> > On 04/26/2012 06:23 AM, Nathan Hintz wrote:
> >> Nathan Hintz (6):
> >>    bcma: Find names of non BCM cores
> >>    bcma: Move initialization of SPROM to prevent overwrite
> >>    bcma: Account for variable PCI memory base/size
> >>    bcma: reads/writes are always 4 bytes, so always map 4 bytes
> >>    bcma: Add __devexit to bcma_host_pci_remove
> >>    bcma: Add flush for BCMA_RESET_CTL write
> >>
> >>   arch/mips/bcm47xx/setup.c      |    4 +++
> >>   arch/mips/bcm47xx/sprom.c      |    2 -
> >>   drivers/bcma/core.c            |    1 +
> >>   drivers/bcma/driver_pci_host.c |   10 +++---
> >>   drivers/bcma/host_pci.c        |    4 +-
> >>   drivers/bcma/scan.c            |   54 +++++++++++++++++++++++++++++----------
> >>   6 files changed, 52 insertions(+), 23 deletions(-)
> >>
> >
> > None of these patches have any description. Some motivation for the
> > changes would be appreciated like 'reported problem', 'new target
> > support', etc.
> 
> I would say that it's required. Anyone can see the diff and see what was
> changed, but nobody will figure out why the change was made unless it's
> described in the commit log. So it's important to answer the question
> "Why?".

Will we be seeing this patchset reposted with better changelogs?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

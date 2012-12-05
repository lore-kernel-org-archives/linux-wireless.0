Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49914 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab2LEV0S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 16:26:18 -0500
Message-ID: <1354742799.24513.4.camel@jlt4.sipsolutions.net> (sfid-20121205_222622_479506_C3731466)
Subject: Re: [PATCH 12/12] iwlwifi: Use standard #defines for PCIe
 Capability ASPM fields
From: Johannes Berg <johannes@sipsolutions.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date: Wed, 05 Dec 2012 22:26:39 +0100
In-Reply-To: <CAErSpo4UuT=_dXqoaGttFxY05Arvm9AhoTBsZhks16C-ZDctAw@mail.gmail.com> (sfid-20121205_222037_899929_816BCEB4)
References: <20121205205724.13851.50508.stgit@bhelgaas.mtv.corp.google.com>
	 <20121205205821.13851.59050.stgit@bhelgaas.mtv.corp.google.com>
	 <1354741486.24513.3.camel@jlt4.sipsolutions.net>
	 <CAErSpo4UuT=_dXqoaGttFxY05Arvm9AhoTBsZhks16C-ZDctAw@mail.gmail.com>
	 (sfid-20121205_222037_899929_816BCEB4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-05 at 14:20 -0700, Bjorn Helgaas wrote:
> On Wed, Dec 5, 2012 at 2:04 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Wed, 2012-12-05 at 13:58 -0700, Bjorn Helgaas wrote:
> >> Use the standard #defines rather than creating local definitions for
> >> PCIe Capability ASPM fields.
> >
> > I'll pick up the iwlwifi ones if you want, or do you want to merge them
> > somewhere centrally instead?
> 
> They do depend on a previous patch that adds the #defines to
> include/uapi/linux/pci_regs.h
> (http://marc.info/?l=linux-pci&m=135474107109010&w=2).
> 
> I think I'll merge at least the PCI core parts of this via my PCI tree
> in the v3.8 merge window next week.  If it won't cause conflicts for
> you, I could include the iwlwifi bits there, too.  If it does, at
> least the #define will exist and you can merge it at your leisure.

Ok, that's fine, feel free to include the iwlwifi bits.

Acked-by: Johannes Berg <johannes.berg@intel.com>

:)

johannes


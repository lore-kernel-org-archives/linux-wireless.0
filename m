Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:55345 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2LEVUh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 16:20:37 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so4723935lag.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2012 13:20:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354741486.24513.3.camel@jlt4.sipsolutions.net>
References: <20121205205724.13851.50508.stgit@bhelgaas.mtv.corp.google.com>
 <20121205205821.13851.59050.stgit@bhelgaas.mtv.corp.google.com> <1354741486.24513.3.camel@jlt4.sipsolutions.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 5 Dec 2012 14:20:15 -0700
Message-ID: <CAErSpo4UuT=_dXqoaGttFxY05Arvm9AhoTBsZhks16C-ZDctAw@mail.gmail.com> (sfid-20121205_222042_434977_48AB4D4B)
Subject: Re: [PATCH 12/12] iwlwifi: Use standard #defines for PCIe Capability
 ASPM fields
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-pci@vger.kernel.org,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 5, 2012 at 2:04 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2012-12-05 at 13:58 -0700, Bjorn Helgaas wrote:
>> Use the standard #defines rather than creating local definitions for
>> PCIe Capability ASPM fields.
>
> I'll pick up the iwlwifi ones if you want, or do you want to merge them
> somewhere centrally instead?

They do depend on a previous patch that adds the #defines to
include/uapi/linux/pci_regs.h
(http://marc.info/?l=linux-pci&m=135474107109010&w=2).

I think I'll merge at least the PCI core parts of this via my PCI tree
in the v3.8 merge window next week.  If it won't cause conflicts for
you, I could include the iwlwifi bits there, too.  If it does, at
least the #define will exist and you can merge it at your leisure.

Bjorn

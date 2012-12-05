Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49839 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab2LEVE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 16:04:27 -0500
Message-ID: <1354741486.24513.3.camel@jlt4.sipsolutions.net> (sfid-20121205_220431_147402_AE1F168F)
Subject: Re: [PATCH 12/12] iwlwifi: Use standard #defines for PCIe
 Capability ASPM fields
From: Johannes Berg <johannes@sipsolutions.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date: Wed, 05 Dec 2012 22:04:46 +0100
In-Reply-To: <20121205205821.13851.59050.stgit@bhelgaas.mtv.corp.google.com> (sfid-20121205_215831_436859_0EDF2BD3)
References: <20121205205724.13851.50508.stgit@bhelgaas.mtv.corp.google.com>
	 <20121205205821.13851.59050.stgit@bhelgaas.mtv.corp.google.com>
	 (sfid-20121205_215831_436859_0EDF2BD3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-05 at 13:58 -0700, Bjorn Helgaas wrote:
> Use the standard #defines rather than creating local definitions for
> PCIe Capability ASPM fields.

I'll pick up the iwlwifi ones if you want, or do you want to merge them
somewhere centrally instead?

johannes


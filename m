Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab2LFIco (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 03:32:44 -0500
Date: Thu, 6 Dec 2012 09:19:57 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 09/12] iwlegacy: collapse wrapper for
 pcie_capability_read_word()
Message-ID: <20121206081956.GA2502@redhat.com> (sfid-20121206_093249_387914_3400E743)
References: <20121205205724.13851.50508.stgit@bhelgaas.mtv.corp.google.com>
 <20121205205806.13851.18014.stgit@bhelgaas.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121205205806.13851.18014.stgit@bhelgaas.mtv.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 05, 2012 at 01:58:06PM -0700, Bjorn Helgaas wrote:
> il_pcie_link_ctl() has only one call site and no longer provides any useful
> abstraction, so collapse it into the caller.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> CC: "John W. Linville" <linville@tuxdriver.com>
> CC: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

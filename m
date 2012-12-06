Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139Ab2LFJCx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 04:02:53 -0500
Date: Thu, 6 Dec 2012 09:20:17 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 11/12] iwlegacy: Use standard #defines for PCIe
 Capability ASPM fields
Message-ID: <20121206082016.GB2502@redhat.com> (sfid-20121206_100316_646651_50B3A6D9)
References: <20121205205724.13851.50508.stgit@bhelgaas.mtv.corp.google.com>
 <20121205205816.13851.86504.stgit@bhelgaas.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121205205816.13851.86504.stgit@bhelgaas.mtv.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 05, 2012 at 01:58:16PM -0700, Bjorn Helgaas wrote:
> Use the standard #defines rather than creating local definitions for
> PCIe Capability ASPM fields.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> CC: "John W. Linville" <linville@tuxdriver.com>
> CC: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

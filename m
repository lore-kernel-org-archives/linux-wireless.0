Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53670 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754718AbeDWMzh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 08:55:37 -0400
Date: Mon, 23 Apr 2018 14:56:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Nipun Gupta <nipun.gupta@nxp.com>, robin.murphy@arm.com,
        hch@lst.de, linux@armlinux.org.uk, gregkh@linuxfoundation.org,
        m.szyprowski@samsung.com, bhelgaas@google.com, zajec5@gmail.com,
        andy.gross@linaro.org, david.brown@linaro.org,
        dan.j.williams@intel.com, vinod.koul@intel.com,
        thierry.reding@gmail.com, robh+dt@kernel.org,
        frowand.list@gmail.com, jarkko.sakkinen@linux.intel.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        johan@kernel.org, msuchanek@suse.de, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-wireless@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pci@vger.kernel.org, bharat.bhushan@nxp.com,
        leoyang.li@nxp.com
Subject: Re: [PATCH v3 1/2] dma-mapping: move dma configuration to bus
        infrastructure
Message-ID: <20180423125657.GC8824@lst.de> (sfid-20180423_145708_746090_3355EE1F)
References: <1520868292-2479-1-git-send-email-nipun.gupta@nxp.com> <1522396485-10248-1-git-send-email-nipun.gupta@nxp.com> <20180410192041.GA54986@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180410192041.GA54986@bhelgaas-glaptop.roam.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 10, 2018 at 02:20:41PM -0500, Bjorn Helgaas wrote:
> I assume you'll merge this via some non-PCI tree.  Let me know if you
> need anything else from me.

I'll take it through the dma-mapping tree, so you should be fine.

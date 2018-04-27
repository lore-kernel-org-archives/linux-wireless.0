Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve1eur01on0087.outbound.protection.outlook.com ([104.47.1.87]:20305
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1758554AbeD0RK4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Apr 2018 13:10:56 -0400
From: Nipun Gupta <nipun.gupta@nxp.com>
To: Christoph Hellwig <hch@lst.de>
CC: "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "zajec5@gmail.com" <zajec5@gmail.com>,
        "andy.gross@linaro.org" <andy.gross@linaro.org>,
        "david.brown@linaro.org" <david.brown@linaro.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "frowand.list@gmail.com" <frowand.list@gmail.com>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "johan@kernel.org" <johan@kernel.org>,
        "msuchanek@suse.de" <msuchanek@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-soc@vger.kernel.org" <linux-soc@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Bharat Bhushan <bharat.bhushan@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
Subject: RE: [PATCH v3 1/2] dma-mapping: move dma configuration to bus
        infrastructure
Date: Fri, 27 Apr 2018 17:10:48 +0000
Message-ID: <HE1PR0401MB24259708C02B6AD57C11A18EE68D0@HE1PR0401MB2425.eurprd04.prod.outlook.com> (sfid-20180427_191107_995024_6BAE5DAB)
References: <1520868292-2479-1-git-send-email-nipun.gupta@nxp.com>
 <1522396485-10248-1-git-send-email-nipun.gupta@nxp.com>
 <20180423125638.GB8824@lst.de>
In-Reply-To: <20180423125638.GB8824@lst.de>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@lst.de]
> Sent: Monday, April 23, 2018 6:27 PM
> To: Nipun Gupta <nipun.gupta@nxp.com>
> Cc: robin.murphy@arm.com; hch@lst.de; linux@armlinux.org.uk;
> gregkh@linuxfoundation.org; m.szyprowski@samsung.com;
> bhelgaas@google.com; zajec5@gmail.com; andy.gross@linaro.org;
> david.brown@linaro.org; dan.j.williams@intel.com; vinod.koul@intel.com;
> thierry.reding@gmail.com; robh+dt@kernel.org; frowand.list@gmail.com;
> jarkko.sakkinen@linux.intel.com; rafael.j.wysocki@intel.com;
> dmitry.torokhov@gmail.com; johan@kernel.org; msuchanek@suse.de; linux-
> kernel@vger.kernel.org; iommu@lists.linux-foundation.org; linux-
> wireless@vger.kernel.org; linux-arm-msm@vger.kernel.org; linux-
> soc@vger.kernel.org; dmaengine@vger.kernel.org; dri-
> devel@lists.freedesktop.org; linux-tegra@vger.kernel.org;
> devicetree@vger.kernel.org; linux-pci@vger.kernel.org; Bharat Bhushan
> <bharat.bhushan@nxp.com>; Leo Li <leoyang.li@nxp.com>
> Subject: Re: [PATCH v3 1/2] dma-mapping: move dma configuration to bus
> infrastructure
>=20
> Can you resend your changes against Linux 4.17-rc2?  There are a lot
> of conflicts as-is.

Sure.. I will send it soon..

Regards,
Nipun

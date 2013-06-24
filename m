Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:34401 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3FXUNY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 16:13:24 -0400
Received: by mail-bk0-f45.google.com with SMTP id je9so4307883bkc.4
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jun 2013 13:13:23 -0700 (PDT)
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Subject: Re: [Ilw] 3.10git: iwlwifi 0000:03:00.0: Request scan called when driver not ready.
Date: Mon, 24 Jun 2013 22:13:21 +0200
Cc: "Berg, Johannes" <johannes.berg@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <201306232021.06721.a.miskiewicz@gmail.com> <0BA3FCBA62E2DC44AF3030971E174FB3019F3492@HASMSX103.ger.corp.intel.com>
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB3019F3492@HASMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201306242213.21567.a.miskiewicz@gmail.com> (sfid-20130624_221328_353871_6E454532)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 24 of June 2013, Grumbach, Emmanuel wrote:
> > Hi.
> > 
> > [46804.179700] dmar: DRHD: handling fault status reg 3
> > [46804.179707] dmar: DMAR:[DMA Read] Request device [03:00.0] fault addr
> > ffed4000
> 
> Fun. So you have an old device with a machine that has IOMMU. Ok...
> 
> > DMAR:[fault reason 06] PTE Read access is not set
> > [46804.220818] iwlwifi 0000:03:00.0: Hardware error detected. 
> > Restarting. [46804.220877] iwlwifi 0000:03:00.0: RF is used by WiMAX
> 
> Did you really use WiMAX here?

No, that kernel doesn't even have wimax support compiled in.

# CONFIG_WIMAX is not set

( disabled wimax sometime ago in my kernel builds... maybe this is 
coincidence)

> 
> > [46807.828033] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 0
> > [46807.828039] iwlwifi 0000:03:00.0: Current SW read_ptr 138 write_ptr
> > 139
> 
> Here, the HW is dead.
> 
> > [46807.828230] iwl data: 00000000: a2 a5 a5 a5 a2 a5 a5 a5 a2 a5 a5 a5 a2
> > a5 a5 a5  ................


-- 
Arkadiusz Miśkiewicz, arekm / maven.pl

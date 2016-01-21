Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51320 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbcAUIsG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 03:48:06 -0500
Date: Thu, 21 Jan 2016 09:47:57 +0100
From: Jean Delvare <jdelvare@suse.de>
To: linux-wireless@vger.kernel.org
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] NFC: microread: Drop platform data header file
Message-ID: <20160121094757.0f151e73@endymion.delvare> (sfid-20160121_094811_090356_1E8A04E5)
In-Reply-To: <20160121092012.0e0f73e1@endymion.delvare>
References: <20160121092012.0e0f73e1@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 21 Jan 2016 09:20:12 +0100, Jean Delvare wrote:
> Originally I only wanted to drop the unneeded inclusion of
> <linux/i2c.h>, but then noticed that struct
> microread_nfc_platform_data isn't actually used, and
> MICROREAD_DRIVER_NAME is redefined in the only file where it is used,
> so we can get rid of the header file and dead code altogether.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Eric Lapuyade <eric.lapuyade@intel.com>

Note: it seems Eric is no longer with Intel so this Cc should be
dropped.

> Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
> Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
> Makes me wonder if this driver is used at all? I can't see any
> instance in the kernel tree.
> (...)

-- 
Jean Delvare
SUSE L3 Support

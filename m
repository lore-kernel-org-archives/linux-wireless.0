Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10917 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085AbcCIW2Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 17:28:16 -0500
Date: Wed, 9 Mar 2016 23:28:12 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-wireless@vger.kernel.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Subject: Re: [PATCH] NFC: microread: Drop platform data header file
Message-ID: <20160309222812.GA21618@zurbaran.home> (sfid-20160309_232819_692078_5728299E)
References: <20160121092012.0e0f73e1@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160121092012.0e0f73e1@endymion.delvare>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jean,

On Thu, Jan 21, 2016 at 09:20:12AM +0100, Jean Delvare wrote:
> Originally I only wanted to drop the unneeded inclusion of
> <linux/i2c.h>, but then noticed that struct
> microread_nfc_platform_data isn't actually used, and
> MICROREAD_DRIVER_NAME is redefined in the only file where it is used,
> so we can get rid of the header file and dead code altogether.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Eric Lapuyade <eric.lapuyade@intel.com>
> Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
> Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
> Makes me wonder if this driver is used at all? I can't see any
> instance in the kernel tree.
The mei part of it is used.


>  MAINTAINERS                             |    1 
>  drivers/nfc/microread/i2c.c             |    8 -------
>  include/linux/platform_data/microread.h |   35 --------------------------------
>  3 files changed, 44 deletions(-)
Applied, thanks.

Cheers,
Samuel.

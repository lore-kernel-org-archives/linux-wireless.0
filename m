Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4530 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbXJZCoO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 22:44:14 -0400
Date: Thu, 25 Oct 2007 22:43:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	mcgrof@gmail.com, jirislaby@gmail.com
Subject: Re: [PATCH 1/2] ath5k: Maintain coding style
Message-ID: <20071026024348.GA14080@tuxdriver.com> (sfid-20071026_034418_311500_D931EEF0)
References: <20071021013630.GB5817@localhost.domain.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071021013630.GB5817@localhost.domain.invalid>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 21, 2007 at 01:36:30AM +0000, Nick Kossifidis wrote:
> * Sort functions in segments like we do on the rest of the code (eg. 
> hw.c). This improves readability and maintainability.
> 
> * Add myself as module author (a patch for this was submited some time 
> ago as part of SFLC's changes but wasn't applied)
> 
> * Declare that this driver is or 5xxx chipset series only in 
> MODULE_SUPPORTED_DEVICE and MODULE_DESCRIPTION.

This patch and the next one do not apply.  Further, after manually
fixing-up this patch it removes a bunch of functions that are still
used.

Would you mind re-diffing and trying again?

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com

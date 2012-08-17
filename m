Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15507 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab2HQWCJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2012 18:02:09 -0400
Date: Sat, 18 Aug 2012 00:02:06 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Syam Sidhardhan <syamsidhardh@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org
Subject: Re: [PATCH] NFC: use module_platform_driver macro for nfcwilink.c
Message-ID: <20120817220206.GB5179@sortiz-mobl> (sfid-20120818_000214_355959_AB7C73A5)
References: <1345019650-5030-1-git-send-email-s.syam@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1345019650-5030-1-git-send-email-s.syam@samsung.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Syam,

On Wed, Aug 15, 2012 at 02:04:10PM +0530, Syam Sidhardhan wrote:
> Simplify the code by make use of module_platform_driver macro.
> 
> Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
> ---
>  drivers/nfc/nfcwilink.c |   16 +---------------
>  1 file changed, 1 insertion(+), 15 deletions(-)
Thanks, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

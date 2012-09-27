Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:64402 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417Ab2I0HMH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 03:12:07 -0400
Date: Thu, 27 Sep 2012 09:12:02 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-nfc@lists.01.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] nfc: add dummy nfc_llc_shdlc_register definition
Message-ID: <20120927071202.GT28670@sortiz-mobl> (sfid-20120927_091212_048141_2E433BC2)
References: <50631EE7.8010203@xenotime.net>
 <1348681150-29095-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1348681150-29095-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Wed, Sep 26, 2012 at 01:39:10PM -0400, John W. Linville wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> 
> This is used when CONFIG_NFC_SHDLC is disabled.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  net/nfc/hci/llc.h | 8 ++++++++
>  1 file changed, 8 insertions(+)

Thanks a lot for fixing this one up.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

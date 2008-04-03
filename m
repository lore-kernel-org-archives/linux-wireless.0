Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56498 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247AbYDCP7S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 11:59:18 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH] iwlwifi: add missing include in iwl-3945-led.c
Date: Thu, 3 Apr 2008 08:58:40 -0700
Message-ID: <D936D925018D154694D8A362EEB089200419511C@orsmsx416.amr.corp.intel.com> (sfid-20080403_165920_592971_76E23210)
In-Reply-To: <47F4AFE8.4020405@yahoo.it>
References: <47F4AFE8.4020405@yahoo.it>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Filippo Zangheri" <filippo.zangheri@yahoo.it>,
	<ipw3945-devel@lists.sourceforge.net>
Cc: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, April 03, 2008 3:23 AM, Filippo Zangheri  wrote:

> iwl-3945-led.c does not include a relevant file.
> 
> Signed-off-by: Filippo Zangheri <filippo.zangheri@yahoo.it> ---
> drivers/net/wireless/iwlwifi/iwl-3945-led.c |    1 +
> 1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
> b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
> index d200d08..7743cac 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
> @@ -40,6 +40,7 @@
> #include <asm/unaligned.h>
> 
> #include "iwl-3945.h"
> +#include "iwl-3945-led.h"
> #include "iwl-helpers.h"
> 
> #define IWL_1MB_RATE (128 * 1024)
> 

... but iwl-3945.h which is just above the line you added already
includes this header file.

Reinette

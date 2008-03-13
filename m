Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9648 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbYCMTRn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2008 15:17:43 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH] iwlwifi: fix a typo in Kconfig message
Date: Thu, 13 Mar 2008 12:10:20 -0700
Message-ID: <D936D925018D154694D8A362EEB0892003E4E3D2@orsmsx416.amr.corp.intel.com> (sfid-20080313_191747_876086_1C688DF8)
In-Reply-To: <1205432004.1469.1.camel@plop>
References: <1205432004.1469.1.camel@plop>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Pascal Terjan" <pterjan@mandriva.com>,
	"Zhu, Yi" <yi.zhu@intel.com>
Cc: <linux-wireless@vger.kernel.org>,
	<ipw3945-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, March 13, 2008 11:13 AM, Pascal Terjan  wrote:

> Signed-off-by: Pascal Terjan <pterjan@mandriva.com> ---
> drivers/net/wireless/iwlwifi/Kconfig |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/Kconfig
> b/drivers/net/wireless/iwlwifi/Kconfig
> index 5b7c016..94b1e34 100644
> --- a/drivers/net/wireless/iwlwifi/Kconfig
> +++ b/drivers/net/wireless/iwlwifi/Kconfig
> @@ -25,7 +25,7 @@ config IWL4965
> 	  runs.
> 
> 	  If you want to compile the driver as a module ( = code which
can be
> -	  inserted in and remvoed from the running kernel whenever you
> want), +	  inserted in and removed from the running kernel
whenever
> 	  you want), say M here and read
> <file:Documentation/kbuild/modules.txt>.  The
> 	  module will be called iwl4965.ko.
> 
> @@ -98,7 +98,7 @@ config IWL3945
> 	  runs.
> 
> 	  If you want to compile the driver as a module ( = code which
can be
> -	  inserted in and remvoed from the running kernel whenever you
> want), +	  inserted in and removed from the running kernel
whenever
> 	  you want), say M here and read
> <file:Documentation/kbuild/modules.txt>.  The
> 	  module will be called iwl3945.ko.
> 
> --
> 1.5.4.3

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Thanks!

Reinette

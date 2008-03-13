Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:10048 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbYCMUYJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2008 16:24:09 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH] iwlwifi: Update git URL
Date: Thu, 13 Mar 2008 13:21:10 -0700
Message-ID: <D936D925018D154694D8A362EEB0892003E8D25A@orsmsx416.amr.corp.intel.com> (sfid-20080313_202416_183170_947B2C60)
In-Reply-To: <1205432413.1469.3.camel@plop>
References: <1205432413.1469.3.camel@plop>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Pascal Terjan" <pterjan@mandriva.com>, <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>, "Zhu, Yi" <yi.zhu@intel.com>,
	<ipw3945-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, March 13, 2008 11:20 AM, Pascal Terjan  wrote:

> Signed-off-by: Pascal Terjan <pterjan@mandriva.com> ---
> MAINTAINERS |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8391b0c..f895d98 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2125,7 +2125,7 @@ M:	reinette.chatre@intel.com
> L:	linux-wireless@vger.kernel.org
> L:	ipw3945-devel@lists.sourceforge.net
> W:	http://intellinuxwireless.org
> -T:	git git://intellinuxwireless.org/repos/iwlwifi
> +T:	git
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless
> -testing.git S:	Supported
> 
> IOC3 ETHERNET DRIVER
> --
> 1.5.4.3

We are actually working on a iwlwifi specific repository on
git.kernel.org. This URL should point there instead. I will submit a
patch for this when the repo is up and running.

Thanks

Reinette

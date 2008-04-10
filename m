Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4138 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140AbYDJVbH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2008 17:31:07 -0400
Date: Thu, 10 Apr 2008 17:29:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: move to generic repository for iwlwifi
Message-ID: <20080410212935.GA29639@tuxdriver.com> (sfid-20080410_223118_349460_0ED6EB34)
References: <1207858587-14503-1-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1207858587-14503-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 10, 2008 at 01:16:27PM -0700, Reinette Chatre wrote:
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> John,
> 
> Is it possible to get this laggard into 2.6.25?
> 
>  MAINTAINERS |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9e63f16..d7c62b2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2116,7 +2116,7 @@ M:	reinette.chatre@intel.com
>  L:	linux-wireless@vger.kernel.org
>  L:	ipw3945-devel@lists.sourceforge.net
>  W:	http://intellinuxwireless.org
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rchatre/iwlwifi-2.6.git
> +T:	git kernel.org:/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
>  S:	Supported

Shouldn't this look like below?

-T:   git git://git.kernel.org/pub/scm/linux/kernel/git/rchatre/iwlwifi-2.6.git
+T:   git git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

John
-- 
John W. Linville
linville@tuxdriver.com

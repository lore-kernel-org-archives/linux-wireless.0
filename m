Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56937 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750901AbbJEM0Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 08:26:24 -0400
Message-ID: <1444047974.27220.10.camel@coelho.fi> (sfid-20151005_142627_554095_46D64A84)
From: Luca Coelho <luca@coelho.fi>
To: Denys Vlasenko <dvlasenk@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 05 Oct 2015 15:26:14 +0300
In-Reply-To: <1443106735-9661-1-git-send-email-dvlasenk@redhat.com>
References: <1443106735-9661-1-git-send-email-dvlasenk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] iwlwifi: Deinline iwl_write8/write32/read32()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Denys,

On Thu, 2015-09-24 at 16:58 +0200, Denys Vlasenko wrote:
> With this .config: http://busybox.net/~vda/kernel_config_ALLYES_Os,
> after deinlining these functions have sizes and callsite counts
> as follows:
> 
> iwl_write8: 315 bytes, 3 calls
> iwl_write32: 296 bytes, 90 calls
> iwl_read32: 278 bytes, 51 calls
> 
> Total size reduction is about 40 kbytes.
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> CC: Johannes Berg <johannes.berg@intel.com>
> CC: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> CC: Intel Linux Wireless <ilw@linux.intel.com>
> CC: Gregory Greenman <gregory.greenman@intel.com>
> CC: John Linville <linville@tuxdriver.com>
> CC: linux-wireless@vger.kernel.org
> CC: linux-kernel@vger.kernel.org

Emmanuel already wrote and applied a patch like this.  Check here:
http://mid.gmane.org/1442869141-31637-4-git-send-email-luca@coelho.fi

Thanks for your patch anyway and for reporting this. :)

--
Cheers,
Luca.

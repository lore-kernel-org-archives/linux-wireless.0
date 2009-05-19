Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58114 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbZESWpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 18:45:16 -0400
Date: Tue, 19 May 2009 18:35:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@linux.intel.com>
Subject: Re: [PATCH v2.6.30 and w-t] iwlwifi: update 5000 ucode support to
	version 2 of API
Message-ID: <20090519223535.GA4635@tuxdriver.com>
References: <1242770196-31072-1-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1242770196-31072-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2009 at 02:56:36PM -0700, Reinette Chatre wrote:
> From: Jay Sternberg <jay.e.sternberg@linux.intel.com>
> 
> enable iwl driver to support 5000 ucode having version 2 of API
> 
> Signed-off-by: Jay Sternberg <jay.e.sternberg@linux.intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> This ucode indicates an API change. The backward compatibility support
> can already be found in 2.6.30 and wireless-testing in commit
> 964c32bdc88b3d15dce34bb9ed0903e78e95fd57 "iwlwifi: correct API command
> overlap"
> 
> Announcement of ucode availability to follow shortly.

Does this fix a bug?  What about it merits inclusion for 2.6.30?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

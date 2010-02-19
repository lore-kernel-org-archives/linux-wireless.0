Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57538 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094Ab0BSUpq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 15:45:46 -0500
Date: Fri, 19 Feb 2010 15:34:21 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, stable@kernel.org,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: Re: [PATCH 3/3] iwlwifi: error checking for number of tfds in queue
Message-ID: <20100219203420.GO4950@tuxdriver.com>
References: <1266559301-19581-1-git-send-email-reinette.chatre@intel.com> <1266559301-19581-4-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1266559301-19581-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 18, 2010 at 10:01:41PM -0800, Reinette Chatre wrote:
> From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> 
> When receive reply_tx and ready to decrement the count for number of
> tfds in queue, do error checking to prevent error condition and
> tfds_in_queue become negative number.
> 
> This fix starts to address
> http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2160 by preventing
> the bad situation from propagation when it does occur. This is needed while
> the cause of the decrement error is still traced.
> 
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> CC: stable@kernel.org

Since this apparently doesn't amount to a fix for the cited issue,
it doesn't seem worth pusing for 2.6.33 at the moment.  Should I take
it in wireless-next-2.6?  Or hold-out for a corrected version?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

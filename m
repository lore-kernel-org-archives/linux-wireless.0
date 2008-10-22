Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58074 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbYJVVQ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 17:16:28 -0400
Date: Wed, 22 Oct 2008 17:15:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 2/2] iwlwifi: don't update TFD free counter for invalid
	station
Message-ID: <20081022211541.GJ15808@tuxdriver.com> (sfid-20081022_231633_719446_B231244F)
References: <1224093984-20779-1-git-send-email-reinette.chatre@intel.com> <1224093984-20779-2-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1224093984-20779-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 15, 2008 at 11:06:24AM -0700, Reinette Chatre wrote:
> From: Tomas Winkler <tomas.winkler@intel.com>
> 
> This patch makes sure that station table is not accessed
> with invalid station id in 4965 TX response path
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Reported-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

This doesn't apply, probably due to the merge failures mentioned
earlier.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.

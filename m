Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37146 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbYJVTwe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 15:52:34 -0400
Date: Wed, 22 Oct 2008 15:51:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 6/9] iwlwifi: refactor TX response flow
Message-ID: <20081022195149.GH15808@tuxdriver.com> (sfid-20081022_215239_047910_EEF0880C)
References: <1224012769-8920-1-git-send-email-reinette.chatre@intel.com> <1224012769-8920-2-git-send-email-reinette.chatre@intel.com> <1224012769-8920-3-git-send-email-reinette.chatre@intel.com> <1224012769-8920-4-git-send-email-reinette.chatre@intel.com> <1224012769-8920-5-git-send-email-reinette.chatre@intel.com> <1224012769-8920-6-git-send-email-reinette.chatre@intel.com> <1224012769-8920-7-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1224012769-8920-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 14, 2008 at 12:32:46PM -0700, Reinette Chatre wrote:
> From: Tomas Winkler <tomas.winkler@intel.com>
> 
> This patch utilize 5000 new TX response command
> which contains all necessary information and avoids
> back referencing to the original TX frame.
> It also change handling of software queue tracking
> 4965 flow is aligned with changes as much as possible.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Reviewed-by: Zhu Yi <yi.zhu@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

What is this based upon?  It doesn't seem to apply to wireless-testing.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.

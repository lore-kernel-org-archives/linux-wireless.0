Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49411 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbYJVTem (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 15:34:42 -0400
Date: Wed, 22 Oct 2008 15:33:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: Re: [PATCH 7/9] iwl3945 : Fix a-band association for passive
	channels
Message-ID: <20081022193353.GG15808@tuxdriver.com> (sfid-20081022_213446_545533_832ACFDF)
References: <1224012769-8920-1-git-send-email-reinette.chatre@intel.com> <1224012769-8920-2-git-send-email-reinette.chatre@intel.com> <1224012769-8920-3-git-send-email-reinette.chatre@intel.com> <1224012769-8920-4-git-send-email-reinette.chatre@intel.com> <1224012769-8920-5-git-send-email-reinette.chatre@intel.com> <1224012769-8920-6-git-send-email-reinette.chatre@intel.com> <1224012769-8920-7-git-send-email-reinette.chatre@intel.com> <1224012769-8920-8-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1224012769-8920-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 14, 2008 at 12:32:47PM -0700, Reinette Chatre wrote:
> From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> 
> This patch fixes the a-band association for passive channels.
> This fix will only work with uCode version 15.28.1.8 and above.
> uCode API version is incremented to 2.
> 
> Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

BTW, what is wrong with "the a-band association for passive channels"?
As you may know, we have been trying to get better changelog
information from the iwlwifi team for a while now...

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.

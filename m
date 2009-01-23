Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59824 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZAWTPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 14:15:47 -0500
Date: Fri, 23 Jan 2009 14:01:39 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>
Subject: Re: [PATCH 2/2 v2.6.29] iwlagn: fix agn rate scaling
Message-ID: <20090123190138.GC30486@tuxdriver.com> (sfid-20090123_201551_530564_F06D6EC1)
References: <1232564283-18008-1-git-send-email-reinette.chatre@intel.com> <1232564283-18008-2-git-send-email-reinette.chatre@intel.com> <1232564283-18008-3-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1232564283-18008-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 21, 2009 at 10:58:03AM -0800, Reinette Chatre wrote:
> From: Abbas, Mohamed <mohamed.abbas@intel.com>
> 
> Sometime Tx reply rate different than what rate scale expecting
> causing rate scale to bail out. This could cause failing to
> commit LQ cmd. This patch will try to solve this instead of just
> bail out. It also make sure we start with a valid rate.
> 
> Signed-off-by: mohamed abbas <mohamed.abbas@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

While I'm sure this would be nice to fix, I don't see the regression,
Oops or crash?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

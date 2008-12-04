Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:55837 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbYLDHYD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 02:24:03 -0500
To: "Reinette Chatre" <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Abbas\, Mohamed" <mohamed.abbas@intel.com>
Subject: Re: [PATCH 07/11] iwl3945: Fix iwl3945 rate scaling.
References: <1228248847-10424-1-git-send-email-reinette.chatre@intel.com>
	<1228248847-10424-2-git-send-email-reinette.chatre@intel.com>
	<1228248847-10424-3-git-send-email-reinette.chatre@intel.com>
	<1228248847-10424-4-git-send-email-reinette.chatre@intel.com>
	<1228248847-10424-5-git-send-email-reinette.chatre@intel.com>
	<1228248847-10424-6-git-send-email-reinette.chatre@intel.com>
	<1228248847-10424-7-git-send-email-reinette.chatre@intel.com>
	<1228248847-10424-8-git-send-email-reinette.chatre@intel.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Thu, 04 Dec 2008 09:23:14 +0200
In-Reply-To: <1228248847-10424-8-git-send-email-reinette.chatre@intel.com> (ext Reinette Chatre's message of "Tue\,  2 Dec 2008 12\:14\:03 -0800")
Message-ID: <874p1kpfod.fsf@nokia.com> (sfid-20081204_082413_771164_F8F3AC93)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reinette Chatre <reinette.chatre@intel.com> writes:

> From: Abbas, Mohamed <mohamed.abbas@intel.com>
>
> 3945 rate scaling was broken in recent tree. This patch fix the following:
> 	1- Get TX response info and update rates window.
> 	2- Rate scaling selection.
> 	3- Flush window timer.
>
> Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

I just updated to latest wireless-testing (commit e81dc4db9) and it
contains this patch. Now rate control is working and iwconfig shows 54
Mbit/s rate when I'm close to AP. Thanks for fixing this.

-- 
Kalle Valo

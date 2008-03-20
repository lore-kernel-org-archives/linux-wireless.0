Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50652 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020AbYCTPSK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2008 11:18:10 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH] iwlwifi: prevent tuning during scanning
Date: Thu, 20 Mar 2008 08:15:30 -0700
Message-ID: <D936D925018D154694D8A362EEB0892003F6F36E@orsmsx416.amr.corp.intel.com> (sfid-20080320_151812_807531_B10CFE18)
In-Reply-To: <1205971612.16475.87.camel@johannes.berg>
References: <1205970201-22241-1-git-send-email-reinette.chatre@intel.com> (sfid-20080319_234534_228497_EC4DD4E8) <1205971612.16475.87.camel@johannes.berg>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<ipw3945-devel@lists.sourceforge.net>,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, March 19, 2008 5:07 PM, Johannes Berg  wrote:

> Wrong patch title. Trying to sneak patches past me? ;)
> 
> Also, I thought you explicitly wanted the channel change callback to
> be allowed during hw scan because hw scan could return to the home
> channel inbetween... 
> 
> johannes

Sorry Johannes - my fault. I just sent it again with corrected title.

Reinette

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22349 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284AbYDBVAn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 17:00:43 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH 0/4] mac80211 and iwlwifi driver updates
Date: Wed, 2 Apr 2008 14:00:21 -0700
Message-ID: <D936D925018D154694D8A362EEB0892004194A96@orsmsx416.amr.corp.intel.com> (sfid-20080402_220047_248453_E1FD9D26)
In-Reply-To: <1206747215-10640-1-git-send-email-reinette.chatre@intel.com>
References: <1206747215-10640-1-git-send-email-reinette.chatre@intel.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>,
	<ipw3945-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, March 28, 2008 4:34 PM, Chatre, Reinette  wrote:

> This series eliminates conf_ht, adds more information to bss_conf, and
> eliminates association from a beacon.
> 
> [PATCH 1/4] mac80211: eliminate conf_ht
> [PATCH 2/4] iwlwifi: eliminate conf_ht
> [PATCH 3/4] mac80211: add association capabilty and timing
> info into bss_conf
> [PATCH 4/4] iwlwifi: Eliminate association from beacon
> 

John and Johannes,

This patch series seems to have slipped through unnoticed. Could you
please consider it for merging to wireless-testing?

Thank you

Reinette

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:44237 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932285AbZGOUcU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 16:32:20 -0400
Subject: Re: [PATCH 03/21] iwlwifi: remove rs_get_rate workaround
From: reinette chatre <reinette.chatre@intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>
In-Reply-To: <1247616853-11221-4-git-send-email-lrodriguez@atheros.com>
References: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
	 <1247616853-11221-4-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Date: Wed, 15 Jul 2009 13:32:18 -0700
Message-Id: <1247689938.17896.2200.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

On Tue, 2009-07-14 at 17:13 -0700, Luis R. Rodriguez wrote:
> This removes the work around implemented for transmitting on
> an unsupported band on iwlwifi. This was added via the patch:
> 
> 8e1856e82cb8f541e925738bebfbc473420cda68:
> iwlwifi: fix rs_get_rate WARN_ON()
> 
> Cc: Mohamed Abbas <mohamed.abbas@intel.com>
> Cc: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

I tried this patch with and without first applying 1/21 "mac80211: drop
frames for sta with no valid rate" but could not reproduce that bug
([1]) anymore. 

Even so ...

Acked-by: Reinette Chatre <reinette.chatre@intel.com

Thank you

Reinette


[1] http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1822



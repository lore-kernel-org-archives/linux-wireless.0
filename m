Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:5345 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932709AbXIGCfO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 22:35:14 -0400
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>
In-Reply-To: <1188991726.9942.99.camel@johannes.berg>
References: <1188875058.13078.428.camel@debian.sh.intel.com>
	 <1188914651.9942.25.camel@johannes.berg>
	 <20070905013804.GA388@mail.intel.com>
	 <1188991726.9942.99.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 07 Sep 2007 10:28:50 +0800
Message-Id: <1189132130.16788.29.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-09-05 at 13:28 +0200, Johannes Berg wrote:
> I've been saying in every second mail
> now: run this driver against the mac80211 in net-2.6.24. It *will*
> trigger a WARN_ON() in the key handling code. 

Where is the WARN_ON? I ran the iwl4965 driver with net-2.6.24 commit-id
3259203776dc4c3f99b9fe3b303e3e76b13f934d, tried WEP, CCMP, no problem,
no WARN_ON. 

Since the mac80211 in net-2.6.24 has some structure change, I modified
the iwlwifi a little bit. You can find the iwlwifi driver for davem's
net-2.6.24 from:
http://intellinuxwireless.org/iwlwifi/v6-iwlwifi-net-2.6.24.patch

Thanks,
-yi

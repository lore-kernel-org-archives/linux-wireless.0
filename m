Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62368 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbXFLITl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 04:19:41 -0400
Subject: Re: [Take 2] mac80211 IEEE802.11e/WMM code cleanup
From: Zhu Yi <yi.zhu@intel.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1ba2fa240706120037g767a330fsa1e838f378ce2b58@mail.gmail.com>
References: <20070611085950.GA5540@mail.intel.com>
	 <1181584907.29767.30.camel@johannes.berg>
	 <1ba2fa240706120037g767a330fsa1e838f378ce2b58@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 12 Jun 2007 16:18:33 +0800
Message-Id: <1181636314.4758.30.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-06-12 at 10:37 +0300, Tomas Winkler wrote:
> This is correct that power save must be disabled explicitly in this
> implementation.  Usually you want to establish DLS for increasing
> throughput so you won't go to power save mode anyway.

Right.

> One other thing is encryption, the path for peer key handshake must be
> opened in mac80211 in addition to this patch. 

Authentication or encryption? I don't think either mac80211 or
wpa_supplicant supports IBSS WPA/WPA2 currently, right. For WEP, it
should work since both DLS peers use the same key as set in the AP.

Thanks,
-yi

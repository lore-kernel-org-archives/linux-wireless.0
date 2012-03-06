Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:47768 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965097Ab2CFNZx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 08:25:53 -0500
Message-ID: <4F561057.5080603@adurom.com> (sfid-20120306_142557_027036_A0C10B58)
Date: Tue, 06 Mar 2012 15:25:43 +0200
From: Kalle Valo <kvalo@adurom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] cfg80211/mac80211: report signal strength for mgmt
 frames
References: <1330692035.8542.14.camel@jlt3.sipsolutions.net>	 <20120305204251.GH18128@tuxdriver.com> <1330982321.3545.13.camel@jlt3.sipsolutions.net>
In-Reply-To: <1330982321.3545.13.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/05/2012 11:18 PM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Add the signal strength (in dBm only for now) to
> frames that are received via nl80211's various
> frame APIs.
> 
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

For the ath6kl part:

Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>

Kalle

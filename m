Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35697 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbbEGMZr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2015 08:25:47 -0400
Message-ID: <1431001545.11214.1.camel@sipsolutions.net> (sfid-20150507_142550_449626_DF4A8206)
Subject: Re: [PATCH v3 5/7] mac80211: Adjust reserved chan_ctx when assigned
 to vif
From: Johannes Berg <johannes@sipsolutions.net>
To: andrei.otc@gmail.com
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Thu, 07 May 2015 14:25:45 +0200
In-Reply-To: <1430926250-14732-1-git-send-email-andrei.otcheretianski@intel.com> (sfid-20150506_173126_872821_BEEE38B8)
References: <1430916630.1954.2.camel@sipsolutions.net>
	 <1430926250-14732-1-git-send-email-andrei.otcheretianski@intel.com>
	 (sfid-20150506_173126_872821_BEEE38B8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-05-06 at 18:30 +0300, andrei.otc@gmail.com wrote:
> From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> 
> When a vif starts using a reserved channel context (during CSA, for example)
> the required chandef was recalculated, however it was never applied.
> This could result in using chanctx with narrower width than actually
> required. Fix this by calling ieee80211_change_chanctx with the recalculated
> chandef. This both changes the chanctx's width and recalcs min_def.

Applied.

johannes


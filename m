Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38687 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab3FRMGR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 08:06:17 -0400
Message-ID: <1371557172.8318.7.camel@jlt4.sipsolutions.net> (sfid-20130618_140628_707919_0DFFFEE2)
Subject: Re: [PATCH] mac80211: track AP's beacon rate and give it to the
 driver
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Date: Tue, 18 Jun 2013 14:06:12 +0200
In-Reply-To: <1370974911-6074-1-git-send-email-johannes@sipsolutions.net> (sfid-20130611_202200_176767_ACF2C20E)
References: <1370974911-6074-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130611_202200_176767_ACF2C20E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-11 at 20:21 +0200, Johannes Berg wrote:
> From: Alexander Bondar <alexander.bondar@intel.com>
> 
> Track the AP's beacon rate in the scan BSS data and in the
> interface configuration to let the drivers know which rate
> the AP is using. This information may be used by drivers,
> in our case to let the firmware optimise beacon RX.

Applied.

johannes


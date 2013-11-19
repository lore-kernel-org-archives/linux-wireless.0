Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41449 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab3KSOfv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 09:35:51 -0500
Message-ID: <1384871747.15364.6.camel@jlt4.sipsolutions.net> (sfid-20131119_153555_605557_34C104DE)
Subject: Re: [PATCH RESEND 5/5] cfg80211: Aggregate mgmt_tx parameters and
 fix channel setting
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Tue, 19 Nov 2013 15:35:47 +0100
In-Reply-To: <1384794409-11211-5-git-send-email-egrumbach@gmail.com> (sfid-20131118_180700_396153_53AB1F8B)
References: <1384794166-10906-1-git-send-email-egrumbach@gmail.com>
	 <1384794409-11211-1-git-send-email-egrumbach@gmail.com>
	 <1384794409-11211-5-git-send-email-egrumbach@gmail.com>
	 (sfid-20131118_180700_396153_53AB1F8B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-11-18 at 19:06 +0200, Emmanuel Grumbach wrote:
> From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> 
> Change cfg80211 and mac80211 to use cfg80211_mgmt_tx_params
> struct to aggregate parameters for mgmt_tx functions.
> This makes the functions' signatures less clumsy and allows
> less painful parameters extension.

Also, technically, this broke a whole bunch of drivers - I'll fix it.

johannes


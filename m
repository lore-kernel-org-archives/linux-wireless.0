Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40301 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab2IRL4d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2012 07:56:33 -0400
Message-ID: <1347969430.4283.7.camel@jlt4.sipsolutions.net> (sfid-20120918_135636_499680_E71C9976)
Subject: Re: [PATCH V2] cfg80211/nl80211: Notify connection request failure
 in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 18 Sep 2012 13:57:10 +0200
In-Reply-To: <1347967249-10703-1-git-send-email-c_ppitch@qca.qualcomm.com>
References: <1347967249-10703-1-git-send-email-c_ppitch@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-18 at 16:50 +0530, Pandiyarajan Pitchaimuthu wrote:
> In AP mode, when a station requests connection to an AP and if the
> request is failed for particular reason, userspace is notified about the
> failure through NL80211_CMD_CONN_FAILED command. Reason for the failure
> is sent through the attribute NL80211_ATTR_CONN_FAILED_REASON.

This didn't apply cleanly, but I fixed it up for you this time.

johannes


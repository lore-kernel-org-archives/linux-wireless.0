Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40082 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab2IRKiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2012 06:38:24 -0400
Message-ID: <1347964742.4283.1.camel@jlt4.sipsolutions.net> (sfid-20120918_123827_298949_81136031)
Subject: Re: [PATCH] cfg80211/nl80211: Notify connection request failure in
 AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 18 Sep 2012 12:39:02 +0200
In-Reply-To: <1347964001-9491-1-git-send-email-c_ppitch@qca.qualcomm.com>
References: <1347964001-9491-1-git-send-email-c_ppitch@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-18 at 15:56 +0530, Pandiyarajan Pitchaimuthu wrote:

> +/**
> + * enum nl80211_connect_failed_reason - The reasons for which an AP could
> + *	have rejected the station's connection request. Any of the mentioned
> + *	reasons are used with the attribute %NL80211_ATTR_CONN_FAILED_REASON
> + *	while sending the event %NL80211_CMD_CONN_FAILED.

Unfortunately, this isn't valid kernel-doc. You should have

 /**
  * name - short description
  * @values
  *
  * long description
  */

johannes


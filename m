Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37943 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933380AbaCSOFv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 10:05:51 -0400
Message-ID: <1395237948.4142.14.camel@jlt4.sipsolutions.net> (sfid-20140319_150554_281139_239A108C)
Subject: Re: [PATCH] cfg80211: make __cfg80211_join_ibss() static
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Mar 2014 15:05:48 +0100
In-Reply-To: <0962cca52541e7067f7c001046fd6d36e7a76640.1394247591.git.gamerh2o@gmail.com> (sfid-20140308_040240_141364_6DE279B4)
References: <0962cca52541e7067f7c001046fd6d36e7a76640.1394247591.git.gamerh2o@gmail.com>
	 (sfid-20140308_040240_141364_6DE279B4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2014-03-08 at 11:01 +0800, Zhao, Gang wrote:
> Function __cfg80211_join_ibss() is only used in net/wireless/ibss.c,
> so make it static.

Applied.

johannes


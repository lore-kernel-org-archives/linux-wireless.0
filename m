Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60781 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab2FIIly (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 04:41:54 -0400
Message-ID: <1339231312.4539.26.camel@jlt3.sipsolutions.net> (sfid-20120609_104159_329476_2B7A59D2)
Subject: Re: [PATCH v2 1/4] {nl,cfg,mac}80211: implement
 dot11MeshHWMProotInterval and dot11MeshHWMPactivePathToRootTimeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org
Date: Sat, 09 Jun 2012 10:41:52 +0200
In-Reply-To: <1339043963-2043-2-git-send-email-yeohchunyeow@gmail.com> (sfid-20120607_063949_035537_F6F9569E)
References: <1339043963-2043-1-git-send-email-yeohchunyeow@gmail.com>
	 <1339043963-2043-2-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20120607_063949_035537_F6F9569E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-07 at 12:39 +0800, Chun-Yeow Yeoh wrote:

> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -827,6 +827,8 @@ struct mesh_config {
>  	bool dot11MeshForwarding;
>  	s32 rssi_threshold;
>  	u16 ht_opmode;
> +	u32 dot11MeshHWMPactivePathToRootTimeout;
> +	u16 dot11MeshHWMProotInterval;

Also in a separate patch, this structure should have kernel-doc. Please
submit a patch for that before adding any more members (I'll take this
patch as-is for now)

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39199 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab3HWN5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 09:57:23 -0400
Message-ID: <1377266238.14021.33.camel@jlt4.sipsolutions.net> (sfid-20130823_155737_294498_975D3D05)
Subject: Re: [PATCH V3] cfg80211: vlan priority handling in WMM
From: Johannes Berg <johannes@sipsolutions.net>
To: cedric.voncken@acksys.fr
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Aug 2013 15:57:18 +0200
In-Reply-To: <1377092917-23411-1-git-send-email-cedric.voncken@acksys.fr>
References: <1377092917-23411-1-git-send-email-cedric.voncken@acksys.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-08-21 at 15:48 +0200, cedric.voncken@acksys.fr wrote:

> +	if(vlan_tx_tag_present(skb)) {

need space

> +		vlan_priority = (vlan_tx_tag_get(skb) & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;

>80 cols

johannes


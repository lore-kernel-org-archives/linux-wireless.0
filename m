Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38257 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab3HWIqO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 04:46:14 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1VCn0X-0005J1-KX
	for linux-wireless@vger.kernel.org; Fri, 23 Aug 2013 10:46:13 +0200
Message-ID: <1377247571.14021.12.camel@jlt4.sipsolutions.net> (sfid-20130823_104619_089963_D4B4BCD5)
Subject: Re: [RFC] mac80211: add ieee80211_iterate_active_interfaces_rtnl()
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 23 Aug 2013 10:46:11 +0200
In-Reply-To: <1377247432-22145-1-git-send-email-johannes@sipsolutions.net> (sfid-20130823_104406_776950_214C4DE3)
References: <1377247432-22145-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130823_104406_776950_214C4DE3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-08-23 at 10:43 +0200, Johannes Berg wrote:

> Change-Id: I9b578c7dacefbb818b4113da12770aec9d0b06c4

will remove ...

> +void __iterate_active_interfaces(struct ieee80211_local *local,
> +				 u32 iter_flags,
> +				 void (*iterator)(void *data, u8 *mac,
> +						  struct ieee80211_vif *vif),
> +				 void *data)

should be static.

johannes


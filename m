Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38684 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab2FIHzg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 03:55:36 -0400
Message-ID: <1339228530.4539.0.camel@jlt3.sipsolutions.net> (sfid-20120609_095613_860811_53D2661E)
Subject: Re: [RFC 0/3] wireless: add CONFIG_CFG80211_EXPERT
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, me@bobcopeland.com,
	mickflemm@gmail.com, kvalo@qca.qualcomm.com
Date: Sat, 09 Jun 2012 09:55:30 +0200
In-Reply-To: <1339203070-17979-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1339203070-17979-1-git-send-email-rodrigue@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-08 at 17:51 -0700, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
> 
> Turns out that standard Linux distributions leave CONFIG_EXPERT
> enabled. This makes this option useless for wireless testing / research
> purposes as we don't want certain features enabled on all kernel
> builds. This adds a new CONFIG_CFG80211_EXPERT and makes a few
> features depend on them.

I'm not sure I see the point in CFG80211_EXPERT. All the features you're
putting in there have nothing to do with cfg80211 at all anyway.

johannes


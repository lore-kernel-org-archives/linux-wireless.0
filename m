Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56497 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaDYPpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 11:45:19 -0400
Message-ID: <1398440696.4152.26.camel@jlt4.sipsolutions.net> (sfid-20140425_174529_304899_094CE35C)
Subject: Re: [PATCH 2/7] mac80211: add get_expected_throughput API
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Fri, 25 Apr 2014 17:44:56 +0200
In-Reply-To: <1397484205-20905-2-git-send-email-antonio@meshcoding.com>
References: <1397484205-20905-1-git-send-email-antonio@meshcoding.com>
	 <1397484205-20905-2-git-send-email-antonio@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-04-14 at 16:03 +0200, Antonio Quartulli wrote:

> +	u32 (*get_expected_throughput)(struct ieee80211_sta *sta);

This isn't nice - it forces drivers to conjure up a value.

You should probably at least allow returning 0 for "no idea" or
something.

johannes



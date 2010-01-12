Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:39171 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab0ALQwx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 11:52:53 -0500
Received: by pwj9 with SMTP id 9so2210155pwj.21
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jan 2010 08:52:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B4BE7AA.4060808@openwrt.org>
References: <4B4BE7AA.4060808@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 12 Jan 2010 08:52:32 -0800
Message-ID: <43e72e891001120852t221106cx4f20ae03959e17e6@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix WMM AC default for non-QoS data frames
To: Felix Fietkau <nbd@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 11, 2010 at 7:08 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> The WMM AC selection added to the monitor mode selection function
> accidentally assigns non-QoS data frames to the same AC as mgmt frames
> (VO). This is not serious, but should be fixed anyway. This patch
> assigns them to the BE AC instead.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

This one I guess is the one I mean John. Someone correct me if I'm
wrong but I believe this piggy backs on top of all the recent fixes
and is a stable candidate.

  Luis

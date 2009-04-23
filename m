Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:40154 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179AbZDWIVa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 04:21:30 -0400
Received: by bwz7 with SMTP id 7so397129bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Apr 2009 01:21:28 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	"Guy\, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: calculate maximum sleep interval
References: <1240418677.30082.3.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 23 Apr 2009 11:21:26 +0300
In-Reply-To: <1240418677.30082.3.camel@johannes.local> (Johannes Berg's message of "Wed\, 22 Apr 2009 18\:44\:37 +0200")
Message-ID: <87mya7bx15.fsf@litku.valot.fi> (sfid-20090423_102150_333235_67492A2E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> The maximum sleep interval, for powersave purposes, is
> determined by the DTIM period (it may not be larger)
> and the required networking latency (it must be small
> enough to fulfil those constraints).
>
> This makes mac80211 calculate the maximum sleep interval
> based on those constraints, and pass it to the driver.
> Then the driver should instruct the device to sleep at
> most that long.
>
> Note that the device is responsible for aligning the
> maximum sleep interval between DTIMs, we make sure it's
> not longer but it needs to make sure it's between them.
>
> Also, group some powersave documentation together and
> make it more explicit that we support managed mode only,
> and no IBSS powersaving (yet).
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Reviewed-by: Kalle Valo <kalle.valo@iki.fi>

-- 
Kalle Valo

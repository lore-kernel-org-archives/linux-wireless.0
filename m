Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:33936 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbZDVT5O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 15:57:14 -0400
Received: by bwz7 with SMTP id 7so165671bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 22 Apr 2009 12:57:12 -0700 (PDT)
To: Bob Copeland <me@bobcopeland.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wl12xx: update to 2.6.29 mac80211 hw scan API
References: <1238897428-19639-1-git-send-email-me@bobcopeland.com>
	<1238897428-19639-2-git-send-email-me@bobcopeland.com>
	<1238921906.3782.5.camel@johannes.local>
	<20090405143357.GA21913@hash.localnet>
	<20090422033845.GA8849@hash.localnet>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 22 Apr 2009 22:57:10 +0300
In-Reply-To: <20090422033845.GA8849@hash.localnet> (Bob Copeland's message of "Tue\, 21 Apr 2009 23\:38\:45 -0400")
Message-ID: <87ljpscvhl.fsf@litku.valot.fi> (sfid-20090422_215719_454319_90024B20)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> The ops->hw_scan callback now takes a struct *cfg80211_scan_request,
> and the scan_completed notifier takes a parameter to indicate whether
> the scan was aborted.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>
> Kalle, this is just an update to 1/6, the others in the series are
> probably ok as-is.
>
> v2: just added the max_scan_ssids.

I dropped the v1 version and took this one instead.

-- 
Kalle Valo

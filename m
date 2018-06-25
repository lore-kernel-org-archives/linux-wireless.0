Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:44282 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbeFYGB7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Jun 2018 02:01:59 -0400
Received: by mail-pg0-f67.google.com with SMTP id b10-v6so1926836pgq.11
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jun 2018 23:01:58 -0700 (PDT)
Subject: Re: [PATCH] nl80211: relax ht operation checks for mesh
To: Bob Copeland <me@bobcopeland.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, kernel-team@fb.com,
        Bob Copeland <bobcopeland@fb.com>
References: <20180625011049.23768-1-me@bobcopeland.com>
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <e520239a-d0e3-cb0d-451b-9794a936f39f@gmail.com> (sfid-20180625_080203_614061_C8370B5F)
Date: Mon, 25 Jun 2018 15:01:55 +0900
MIME-Version: 1.0
In-Reply-To: <20180625011049.23768-1-me@bobcopeland.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018/06/25 10:10, Bob Copeland wrote:> The latter bit is actually 
reserved for mesh BSSes
> according to Table 9-168 in 802.11-2016, so in fact it should not
> be set.

Good catch !
Indeed the bit is reserved at non-AP case.

Reviewed-by: Masashi Honma <masashi.honma@gmail.com>

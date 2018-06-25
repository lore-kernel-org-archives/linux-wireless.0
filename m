Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:43022 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752293AbeFYFye (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Jun 2018 01:54:34 -0400
Received: by mail-pl0-f68.google.com with SMTP id c41-v6so6283053plj.10
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jun 2018 22:54:34 -0700 (PDT)
Subject: Re: [PATCH] nl80211: relax ht operation checks for mesh
To: Bob Copeland <me@bobcopeland.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, kernel-team@fb.com,
        Bob Copeland <bobcopeland@fb.com>
References: <20180625011049.23768-1-me@bobcopeland.com>
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <b79e6cd2-febd-ba6e-f76c-aa78aac2bb42@gmail.com> (sfid-20180625_075441_792556_62498441)
Date: Mon, 25 Jun 2018 14:54:30 +0900
MIME-Version: 1.0
In-Reply-To: <20180625011049.23768-1-me@bobcopeland.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018/06/25 10:10, Bob Copeland wrote:
> The latter bit is actually reserved for mesh BSSes
> according to Table 9-168 in 802.11-2016, so in fact it should not
> be set.

Good catch !
Indeed the bit is reserved at non-AP case.

Reviewed-by: Masashi Honma <masashi.honma@gmail.com>

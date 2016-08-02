Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35135 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521AbcHBLqH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 07:46:07 -0400
Received: by mail-pa0-f45.google.com with SMTP id iw10so62790481pac.2
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2016 04:46:06 -0700 (PDT)
Subject: Re: [PATCH] nl80211: Expand max value of NL80211_MESHCONF_HT_OPMODE
 command
To: Johannes Berg <johannes@sipsolutions.net>
References: <1468927556-4703-1-git-send-email-masashi.honma@gmail.com>
 <1470123822.2665.9.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, j@w1.fi, me@bobcopeland.com
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <abcafb2b-a6f1-6599-0b97-2cc6ce4d72a7@gmail.com> (sfid-20160802_192431_276916_BFCC6FE3)
Date: Tue, 2 Aug 2016 20:40:47 +0900
MIME-Version: 1.0
In-Reply-To: <1470123822.2665.9.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016年08月02日 16:43, Johannes Berg wrote:
> You're now changing it to 23, which makes some sense, but is kinda
> strange. It allows setting the unused bit 0x8 by itself or in
> combination with any protection and/or the NON_GF bit, but not in
> combination with the NON_HT bit.

Thanks. This is reasonable. I will implement bitwise checks.

Masashi Honma.

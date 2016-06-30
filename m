Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:36639 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbcF3MBE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 08:01:04 -0400
Received: by mail-pf0-f169.google.com with SMTP id t190so28952705pfb.3
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2016 05:01:04 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: Add mesh peer AID setting API
To: Bob Copeland <me@bobcopeland.com>
References: <1467277258-2331-1-git-send-email-masashi.honma@gmail.com>
 <20160630111110.GF9984@localhost>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org, j@w1.fi
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <577509FD.7040906@gmail.com> (sfid-20160630_140110_052769_05573C14)
Date: Thu, 30 Jun 2016 21:01:01 +0900
MIME-Version: 1.0
In-Reply-To: <20160630111110.GF9984@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016年06月30日 20:11, Bob Copeland wrote:
> Let's call it peer_aid or mesh_peer_aid or something like that, per my
> email on hostapd list.  Also you probably saw kbuild robot pointed out
> missing documentation for the field.
Yes. I will modify this also.

> We need a check against IEEE80211_MAX_AID somewhere.
Sure. I will add a check.


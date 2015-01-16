Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:60370 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbbAPGMU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 01:12:20 -0500
Received: by mail-ig0-f176.google.com with SMTP id hl2so99596igb.3
        for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2015 22:12:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87iog7nukb.fsf@kamboji.qca.qualcomm.com>
References: <1421385460-3126-1-git-send-email-masashi.honma@gmail.com>
	<87iog7nukb.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 16 Jan 2015 15:12:20 +0900
Message-ID: <CAFk-A4kzcC9BhCtwqxjprRiXZeVPepBDXr3TvqvL6hn6J37UGw@mail.gmail.com> (sfid-20150116_071224_067697_2492F75E)
Subject: Re: [PATCH] mesh: Avoid STA expiration timer truncation to u32
From: Masashi Honma <masashi.honma@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-01-16 14:49 GMT+09:00 Kalle Valo <kvalo@codeaurora.org>:
> For mac80211 patches please use prefix "mac80211: ".

Thanks. I will fix it.

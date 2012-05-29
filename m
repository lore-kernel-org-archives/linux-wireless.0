Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:47811 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751497Ab2E2OjY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 10:39:24 -0400
Received: by obbtb18 with SMTP id tb18so9318166obb.5
        for <linux-wireless@vger.kernel.org>; Tue, 29 May 2012 07:39:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338275484.4342.22.camel@jlt3.sipsolutions.net>
References: <1337669130-4229-1-git-send-email-victorg@ti.com>
	<1337712022.4470.0.camel@jlt3.sipsolutions.net>
	<CAK80WHZW8OLs8N9vPhLx8+yVUhOnFU8EGyHQX=Es12gzZ32rNg@mail.gmail.com>
	<CAK80WHbLfOYgvNqoyZroGC6zvWs8UYNwRP_TzLmzDjVSqJK8XA@mail.gmail.com>
	<1338275484.4342.22.camel@jlt3.sipsolutions.net>
Date: Tue, 29 May 2012 17:39:22 +0300
Message-ID: <CAK80WHaKhua9hqMcKZcruvEYv0d5TO+Ln-fU+HVB1GsQY+Knfg@mail.gmail.com> (sfid-20120529_163930_617615_22206E0A)
Subject: Re: [PATCH] mac80211: add command to get current rssi
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 29, 2012 at 10:11 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> if (!local->ops->get_rssi) || (drv_get_rssi(local, sdata,
>> sta->sta.addr, &sinfo->signal))
>>         sinfo->signal = (s8)sta->last_signal;
>
> However, I think you should pass &sta->sta, not sta->sta.addr.
>

Will send v2 with the above change.

-- 
Thanks,
Victor.

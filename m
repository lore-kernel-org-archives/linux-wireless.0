Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:58830 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752109Ab2EaM3K convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 08:29:10 -0400
Received: by lagy4 with SMTP id y4so702402lag.29
        for <linux-wireless@vger.kernel.org>; Thu, 31 May 2012 05:29:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338464568.9102.2.camel@jlt3.sipsolutions.net>
References: <1338463991-7741-1-git-send-email-victorg@ti.com>
	<1338464568.9102.2.camel@jlt3.sipsolutions.net>
Date: Thu, 31 May 2012 15:29:07 +0300
Message-ID: <CAK80WHa3F2XBAO+BexgwB4oZKkQTD8UT3G6tEZTOk_Dq2pO-KQ@mail.gmail.com> (sfid-20120531_142914_158826_78E58BE0)
Subject: Re: [PATCH v2] mac80211: add command to get current rssi
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 31, 2012 at 2:42 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-05-31 at 14:33 +0300, Victor Goldenshtein wrote:
>
>> -             sinfo->signal = (s8)sta->last_signal;
>> +             if (!local->ops->get_rssi ||
>> +                     drv_get_rssi(local, sdata, &sta->sta, &sinfo->signal))
>> +                     sinfo->signal = (s8)sta->last_signal;
>
> Please fix the indentation here
>

will send v3 in a minute.

-- 
Thanks,
Victor.

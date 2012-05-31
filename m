Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:49949 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757944Ab2EaNGP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 09:06:15 -0400
Received: by lbbgk8 with SMTP id gk8so886669lbb.26
        for <linux-wireless@vger.kernel.org>; Thu, 31 May 2012 06:06:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338468480.9102.5.camel@jlt3.sipsolutions.net>
References: <1338467755-8331-1-git-send-email-victorg@ti.com>
	<1338468480.9102.5.camel@jlt3.sipsolutions.net>
Date: Thu, 31 May 2012 16:06:13 +0300
Message-ID: <CAK80WHYMUtNLg-RcppWc8h561+tLi3P0GE9iY+LV8YnbJyYgrA@mail.gmail.com> (sfid-20120531_150619_516641_CC276F22)
Subject: Re: [PATCH v3] mac80211: add command to get current rssi
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 31, 2012 at 3:48 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-05-31 at 15:35 +0300, Victor Goldenshtein wrote:
>
>> +DEFINE_EVENT(local_sdata_evt, drv_get_rssi,
>> +     TP_PROTO(struct ieee80211_local *local,
>> +              struct ieee80211_sub_if_data *sdata),
>> +     TP_ARGS(local, sdata)
>> +);
>
> Shouldn't that also trace the station?
>

I don't know, what you think we should trace there ?

-- 
Thanks,
Victor.

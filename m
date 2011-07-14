Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59626 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab1GNKLF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 06:11:05 -0400
Received: by gyh3 with SMTP id 3so34841gyh.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2011 03:11:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87mxghw4zy.fsf@purkki.adurom.net>
References: <1310628070-6012-1-git-send-email-eliad@wizery.com>
	<87mxghw4zy.fsf@purkki.adurom.net>
Date: Thu, 14 Jul 2011 13:11:04 +0300
Message-ID: <CAB3XZEdzfeLvyR=7YcdLZme+vznAqyTQ4dQJ5_YsvdhY2moudQ@mail.gmail.com> (sfid-20110714_121109_135972_2DB0FA61)
Subject: Re: [PATCH] mac80211: reconfigure tx on device reconfiguration
From: Eliad Peller <eliad@wizery.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 14, 2011 at 1:06 PM, Kalle Valo <kvalo@adurom.com> wrote:
> Eliad Peller <eliad@wizery.com> writes:
>
>> Add tx_conf array to save the current tx queues
>> configuration, and reconfig it on resume (ieee80211_reconfig).
>
> Why? You could describe a bit in the commit log what real (or user
> visible) issue this patch fixes. I can guess but usually my guesses
> are wrong ;)
>
heh.
sure. i'll send v2 soon (if there won't be other comments).

Eliad.

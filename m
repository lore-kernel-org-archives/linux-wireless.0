Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50137 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab0LBXrU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 18:47:20 -0500
Received: by gwj20 with SMTP id 20so4476015gwj.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 15:47:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTik69KDgWsHJkpAUtZY-uwAKpXLGUcrmerQbcHwM@mail.gmail.com>
References: <1291331474-16475-1-git-send-email-eliad@wizery.com>
	<AANLkTik69KDgWsHJkpAUtZY-uwAKpXLGUcrmerQbcHwM@mail.gmail.com>
Date: Fri, 3 Dec 2010 01:47:19 +0200
Message-ID: <AANLkTi=4tzzeW76MsizZtJRs3wRHs8oJF2RVDAWKJueQ@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix pm_qos magic numbers
From: Eliad Peller <eliad@wizery.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 3, 2010 at 1:35 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Dec 2, 2010 at 3:11 PM, Eliad Peller <eliad@wizery.com> wrote:
>> the default /dev/network_latency is 2000s.
>> 1900ms = 1900000us.
>> just use consts.
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>
> I'm sorry, I don't understand what your description is saying, can you
> elaborate on it some more so that when review this on the commit log
> it is crystal clear what you meant?
>
sorry.
i'll send an updated commit message.
hope it will be clearer.

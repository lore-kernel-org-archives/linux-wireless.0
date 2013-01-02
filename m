Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51035 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab3ABWpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 17:45:07 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr12so6606644wgb.23
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jan 2013 14:45:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1357131065.9839.14.camel@jlt4.sipsolutions.net>
References: <1356644636-5309-1-git-send-email-thomas@cozybit.com>
 <1356644636-5309-2-git-send-email-thomas@cozybit.com> <1357131065.9839.14.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Wed, 2 Jan 2013 14:44:45 -0800
Message-ID: <CAG6hwVNK9Xt-OAjF-vioAyVXFQBzhF-xUdd1cY0GQRBfXusqQA@mail.gmail.com> (sfid-20130102_234511_161787_A8975322)
Subject: Re: [PATCH 2/4] mac80211_hwsim: hrtimer beacon
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.org, j@w1.fi, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 2, 2013 at 4:51 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2012-12-27 at 13:43 -0800, Thomas Pedersen wrote:
>
>>       ieee80211_iterate_active_interfaces_atomic(
>>               hw, IEEE80211_IFACE_ITER_NORMAL,
>> -             mac80211_hwsim_beacon_tx, hw);
>> +             mac80211_hwsim_beacon_tx, data);
>
> This change belongs to another patch, please respin cleanly.

D'oh. Yes it does, will send a v2 shortly.

Thanks,

Thomas

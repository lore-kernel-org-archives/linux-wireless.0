Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36859 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab0GWR3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 13:29:36 -0400
Received: by pwi5 with SMTP id 5so3596746pwi.19
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jul 2010 10:29:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1279864868.3745.0.camel@jlt3.sipsolutions.net>
References: <19529.9687.183293.284789@gargle.gargle.HOWL> <1279864868.3745.0.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 23 Jul 2010 10:29:14 -0700
Message-ID: <AANLkTim0Zv8E6Kc60W9m6krL-FOzXiJpeHTGgoR2DH9i@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Don't set per-BSS QoS for monitor interfaces
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sujith <Sujith.Manoharan@atheros.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 22, 2010 at 11:01 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2010-07-23 at 10:47 +0530, Sujith wrote:
>> In AP mode, there is no need to notify the driver about QoS
>> changes for the monitor interface that is created. The warning
>> in ieee80211_bss_info_change_notify() would be hit otherwise.
>
> Makes sense.
>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
>> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>

Stable?

  Luis

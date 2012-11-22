Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55750 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab2KVUlC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 15:41:02 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so8364374oag.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 12:41:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20652.56145.6291.392891@gargle.gargle.HOWL>
References: <1353381362-437-1-git-send-email-sujith@msujith.org>
	<1353494712.10444.20.camel@jlt4.sipsolutions.net>
	<CANUX_P3e4ut9Jh25wXP7dOcvQh_YhuZ_LCkQV4QHpaNGrzbYuQ@mail.gmail.com>
	<20652.56145.6291.392891@gargle.gargle.HOWL>
Date: Thu, 22 Nov 2012 13:17:25 +0200
Message-ID: <CANUX_P12Zs0m+v_0E09MZ7+_3aSgLkotG2GgVhHmUw0vm_SdBQ@mail.gmail.com> (sfid-20121122_214124_784718_A2C746B8)
Subject: Re: [PATCH] mac80211: Add debugfs callbacks for station addition/removal
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Emmanuel Grumbach wrote:
>> Do you see value to add this for vif too?
>
> Not sure, mac80211 currently doesn't have a per-VIF debugfs area.
> Also, we have ieee80211_iterate_active_interfaces(), which could be used
> by drivers.
>

Well it does: under sdata.
Anyway I added it internally. Patch will be posted soon :-)

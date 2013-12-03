Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:63844 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab3LCIwW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 03:52:22 -0500
Received: by mail-la0-f47.google.com with SMTP id ep20so8757530lab.20
        for <linux-wireless@vger.kernel.org>; Tue, 03 Dec 2013 00:52:20 -0800 (PST)
Message-ID: <529D9BBE.6040900@gmail.com> (sfid-20131203_095227_929396_F210B941)
Date: Tue, 03 Dec 2013 09:52:14 +0100
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
CC: j@w1.fi, Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC] cfg80211/mac80211: drop GTK-protected unicast IP packets
References: <1386010316-2540-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1386010316-2540-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-12-02 19:51, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> The GTK is shared by all stations in an 802.11 BSS and as such any
> one of them can send forged group-addressed frames. To prevent this
> kind of attack, drop unicast IP packets if they were protected with
> the GTK, i.e. were multicast packets at the 802.11 layer.
>

[...]

>
> +/**
> + * cfg80211_is_ip_unicast - check if packet is IP unicast
> + * @skb: skb, in 802.3 format
> + */
> +bool cfg80211_is_ip_unicast(struct sk_buff *skb);
> +

Not implemented anywhere. Leftovers?

Cheers,

Pontus


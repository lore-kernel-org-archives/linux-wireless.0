Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:48077 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752993AbcJCLfF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Oct 2016 07:35:05 -0400
Subject: Re: [PATCH] mac80211: fix CMD_FRAME for AP_VLAN
To: johannes@sipsolutions.net
References: <1474786035-15410-1-git-send-email-michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
From: "M. Braun" <michael-dev@fami-braun.de>
Message-ID: <fb4aeb32-8a13-92e6-a84e-12a6228dc7a1@fami-braun.de> (sfid-20161003_133524_641716_6F94B231)
Date: Mon, 3 Oct 2016 13:31:26 +0200
MIME-Version: 1.0
In-Reply-To: <1474786035-15410-1-git-send-email-michael-dev@fami-braun.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 03.10.2016 um 13:03 schrieb M. Braun:
> because the in ieee80211_mgmt_tx the

ups, that was the patch itself.

I think I carried it over from ieee80211_add_key, that does

>
>        if (mac_addr) {
>                if (ieee80211_vif_is_mesh(&sdata->vif))
>                        sta = sta_info_get(sdata, mac_addr);
>                else
>                        sta = sta_info_get_bss(sdata, mac_addr);
>

Regards,
M. Braun

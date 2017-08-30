Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0059.outbound.protection.outlook.com ([104.47.37.59]:32094
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751323AbdH3MVO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 08:21:14 -0400
Date: Wed, 30 Aug 2017 15:20:59 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: igor.mitsyanko.os@quantenna.com, linux-wireless@vger.kernel.org,
        avinashp@quantenna.com, johannes@sipsolutions.net
Subject: Re: [PATCH 21/27] qtnfmac: extend "IE set" TLV to include frame type
 info
Message-ID: <20170830122058.2piz47avmvyxmfee@bars> (sfid-20170830_142118_451801_94EC3E3E)
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
 <20170825023024.10565-22-igor.mitsyanko.os@quantenna.com>
 <20170830120635.62m2eupefizpgcto@bars>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170830120635.62m2eupefizpgcto@bars>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Two points here. First, it looks like there is a problem here inherited
> from the existing implementation. We go through payload, but in fact we
> pass to cfg80211_inform_bss only the last QTN_TLV_ID_IE_SET element.
> Second, it looks like QTN_TLV_ID_IE_SET here should be treated in
> the same way as in qtnf_event_handle_sta_assoc, to avoid confusion.
> In other words, either we use only QTN_TLV_ID_IE_SET in both cases,
> or switch to specific qlink_tlv_ie_set elements.

Ignore the second point: it is addressed by the next patch.

Regards,
Sergey

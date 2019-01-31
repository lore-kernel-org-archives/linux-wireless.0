Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D929C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 17:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF14C20B1F
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 17:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfAaRqB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 12:46:01 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:54058 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726507AbfAaRqB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 12:46:01 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gpGPX-0006VT-8q; Thu, 31 Jan 2019 18:45:59 +0100
Message-ID: <5d1ee63b4baa1420f65467b29b0ec97efea46559.camel@sipsolutions.net>
Subject: Re: Subject: [PATCH 1/2] mac80211: Add support for
 NL80211_STA_INFO_AIRTIME_LINK_METRIC
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Narayanraddi Masti <nmasti@google.com>
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 31 Jan 2019 18:45:57 +0100
In-Reply-To: <CAGsRCcm2-Z+ifg48tpG_tsW2jWjBCgLZchQzVmZxbZjhO45JbQ@mail.gmail.com> (sfid-20190131_030024_464866_CC83FFAC)
References: <CAGsRCcm2-Z+ifg48tpG_tsW2jWjBCgLZchQzVmZxbZjhO45JbQ@mail.gmail.com>
         (sfid-20190131_030024_464866_CC83FFAC)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

Unfortunately, just about everything with this patch was wrong :-)

 * extra "Subject: " in the subject, what happened there?
 * HTML email
 * every netlink attribute enum says you cannot add in the middle ...

> @@ -3111,6 +3112,7 @@ enum nl80211_sta_info {
>  	NL80211_STA_INFO_BEACON_SIGNAL_AVG,
>  	NL80211_STA_INFO_TID_STATS,
>  	NL80211_STA_INFO_RX_DURATION,
> +	NL80211_STA_INFO_AIRTIME_LINK_METRIC,
>  	NL80211_STA_INFO_PAD,
>  	NL80211_STA_INFO_ACK_SIGNAL,
>  	NL80211_STA_INFO_ACK_SIGNAL_AVG,

johannes


Return-Path: <SRS0=yvfE=2B=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A53C43603
	for <linux-wireless@archiver.kernel.org>; Wed, 11 Dec 2019 21:21:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 036F620637
	for <linux-wireless@archiver.kernel.org>; Wed, 11 Dec 2019 21:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfLKVV2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 11 Dec 2019 16:21:28 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:41208 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbfLKVV1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Dec 2019 16:21:27 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1if9QE-0055po-5d; Wed, 11 Dec 2019 22:21:26 +0100
Message-ID: <df7eb0b71dc9cfdc7d9b5f7abdbcce0d42fa4a1e.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] mac80211: Turn AQL into an NL80211_EXT_FEATURE
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        linux-wireless@vger.kernel.org
Date:   Wed, 11 Dec 2019 22:21:23 +0100
In-Reply-To: <20191211145230.200132-2-toke@redhat.com> (sfid-20191211_155248_543703_36481311)
References: <20191211145230.200132-1-toke@redhat.com>
         <20191211145230.200132-2-toke@redhat.com>
         (sfid-20191211_155248_543703_36481311)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-12-11 at 15:52 +0100, Toke Høiland-Jørgensen wrote:
> 
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 341e0e8cae46..1e6f435c709c 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -5563,6 +5563,7 @@ enum nl80211_ext_feature_index {
>  	NL80211_EXT_FEATURE_STA_TX_PWR,
>  	NL80211_EXT_FEATURE_SAE_OFFLOAD,
>  	NL80211_EXT_FEATURE_VLAN_OFFLOAD,
> +	NL80211_EXT_FEATURE_AQL,

This is missing kernel-doc.

johannes


Return-Path: <SRS0=efDY=C3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C9A1C43463
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Sep 2020 10:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2722920848
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Sep 2020 10:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgIRKrl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Sep 2020 06:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgIRKrl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Sep 2020 06:47:41 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FBDC06174A
        for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2020 03:47:41 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kJDvX-006Ch4-Hf; Fri, 18 Sep 2020 12:47:39 +0200
Message-ID: <56d639c4f045b205ab311ab80c0ff5a18d4af7fb.camel@sipsolutions.net>
Subject: Re: [PATCH v2 08/22] nl80211: support S1G capabilities
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Thomas Pedersen <thomas@adapt-ip.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Date:   Fri, 18 Sep 2020 12:47:38 +0200
In-Reply-To: <20200831205600.21058-9-thomas@adapt-ip.com>
References: <20200831205600.21058-1-thomas@adapt-ip.com>
         <20200831205600.21058-9-thomas@adapt-ip.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2020-08-31 at 13:55 -0700, Thomas Pedersen wrote:
> @@ -3046,6 +3054,7 @@ enum nl80211_attrs {
>  #define NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY	24
>  #define NL80211_HT_CAPABILITY_LEN		26
>  #define NL80211_VHT_CAPABILITY_LEN		12
> +#define NL80211_S1G_CAPABILITY_LEN		15

Maybe that would make more sense in ieee80211.h? Renamed, of course?

johannes


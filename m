Return-Path: <SRS0=v5bw=7J=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1171C433E0
	for <linux-wireless@archiver.kernel.org>; Wed, 27 May 2020 14:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA4BD208C3
	for <linux-wireless@archiver.kernel.org>; Wed, 27 May 2020 14:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388809AbgE0O24 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 May 2020 10:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388899AbgE0O24 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 May 2020 10:28:56 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D82CC08C5C4
        for <linux-wireless@vger.kernel.org>; Wed, 27 May 2020 07:28:56 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jdx38-0049jw-Sr; Wed, 27 May 2020 16:28:54 +0200
Message-ID: <f26e82321f4df75041e3013eb8128ef60048f7fe.camel@sipsolutions.net>
Subject: Re: [PATCH v3 05/11] mac80211: fix memory overlap due to variable
 length param
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>, kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, ath11k@lists.infradead.org
Date:   Wed, 27 May 2020 16:28:53 +0200
In-Reply-To: <1589399105-25472-5-git-send-email-rmanohar@codeaurora.org>
References: <1589399105-25472-1-git-send-email-rmanohar@codeaurora.org>
         <1589399105-25472-5-git-send-email-rmanohar@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2020-05-13 at 12:44 -0700, Rajkumar Manoharan wrote:
> As of now HE operation element in bss_conf includes variable length
> optional field followed by other HE variable. Though the optional
> field never be used, actually it is referring to next member of the
> bss_conf structure which is not correct. Fix it by declaring needed
> HE operation fields within bss_conf itself.

I had already applied this.

johannes


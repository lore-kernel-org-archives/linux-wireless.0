Return-Path: <SRS0=v5bw=7J=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3AB3C433DF
	for <linux-wireless@archiver.kernel.org>; Wed, 27 May 2020 14:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5E082084C
	for <linux-wireless@archiver.kernel.org>; Wed, 27 May 2020 14:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389222AbgE0OaY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 May 2020 10:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389033AbgE0OaX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 May 2020 10:30:23 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4825C05BD1E
        for <linux-wireless@vger.kernel.org>; Wed, 27 May 2020 07:30:23 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jdx4Y-0049om-1t; Wed, 27 May 2020 16:30:22 +0200
Message-ID: <db25e743c1d71fb97af71c9aee2fec8a3c34ecd1.camel@sipsolutions.net>
Subject: Re: [PATCH v3 08/11] mac80211: build HE operation with 6 GHz oper
 information
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>, kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, ath11k@lists.infradead.org
Date:   Wed, 27 May 2020 16:30:19 +0200
In-Reply-To: <1589399105-25472-8-git-send-email-rmanohar@codeaurora.org>
References: <1589399105-25472-1-git-send-email-rmanohar@codeaurora.org>
         <1589399105-25472-8-git-send-email-rmanohar@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2020-05-13 at 12:45 -0700, Rajkumar Manoharan wrote:
> Add 6 GHz operation information (IEEE 802.11ax/D6.0, Figure 9-787k)
> while building HE operation element for non-HE AP. This field is used to
> determine channel information in the absence of HT/VHT IEs.

We didn't have this at all since we focused on client side.

Looks good.

johannes


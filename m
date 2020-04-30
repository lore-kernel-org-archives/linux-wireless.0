Return-Path: <SRS0=B82j=6O=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B20C8300A
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Apr 2020 11:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8ADC2076D
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Apr 2020 11:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgD3Lht (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 30 Apr 2020 07:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726127AbgD3Lht (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Apr 2020 07:37:49 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1F8C035494
        for <linux-wireless@vger.kernel.org>; Thu, 30 Apr 2020 04:37:49 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jU7Vh-002b5i-IB; Thu, 30 Apr 2020 13:37:45 +0200
Message-ID: <450305028ea9174998726c1647b08361a88dced5.camel@sipsolutions.net>
Subject: Re: [PATCH v3 1/5] cfg80211: add KHz variants of frame RX API
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Thomas Pedersen <thomas@adapt-ip.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Date:   Thu, 30 Apr 2020 13:37:44 +0200
In-Reply-To: <20200430010642.22552-2-thomas@adapt-ip.com>
References: <20200430010642.22552-1-thomas@adapt-ip.com>
         <20200430010642.22552-2-thomas@adapt-ip.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2020-04-29 at 18:06 -0700, Thomas Pedersen wrote:
> 
> +#define PR_KHZ(f) KHZ_TO_MHZ((float) f)

You can't use float, sorry.

johannes


Return-Path: <SRS0=AjYM=2X=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D9A9C2D0DC
	for <linux-wireless@archiver.kernel.org>; Thu,  2 Jan 2020 13:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1358121734
	for <linux-wireless@archiver.kernel.org>; Thu,  2 Jan 2020 13:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbgABNpH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 2 Jan 2020 08:45:07 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:57830 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728342AbgABNpH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Jan 2020 08:45:07 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1in0mg-005TAP-23; Thu, 02 Jan 2020 14:45:06 +0100
Message-ID: <de5fdc38a085de022f75a23883d9e498e5123e88.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: Enhance the AKM advertizement to support per
 interface.
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Veerendranath Jakkam <vjakkam@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 02 Jan 2020 14:45:04 +0100
In-Reply-To: <20191223185255.1009-1-vjakkam@codeaurora.org> (sfid-20191223_195313_440449_C90A4A92)
References: <20191223185255.1009-1-vjakkam@codeaurora.org>
         (sfid-20191223_195313_440449_C90A4A92)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-12-24 at 00:22 +0530, Veerendranath Jakkam wrote:
> 
> @@ -4587,9 +4598,6 @@ struct wiphy {
>  	int n_cipher_suites;
>  	const u32 *cipher_suites;
>  
> -	int n_akm_suites;
> -	const u32 *akm_suites;

Certainly this also breaks compiling a large number of drivers... ???

johannes


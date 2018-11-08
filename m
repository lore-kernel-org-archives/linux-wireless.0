Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40964ECDE4B
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 20:26:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FB1A206BA
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 20:26:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FB1A206BA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbeKIGDf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 01:03:35 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:47804 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725723AbeKIGDf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 01:03:35 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gKqsm-00077n-AW; Thu, 08 Nov 2018 21:26:28 +0100
Message-ID: <28da4c280a45c6e81883ed2f45276be28ddc0a72.camel@sipsolutions.net>
Subject: Re: [iw] [patch] Please support CPPFLAGS in Makefile
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Paride Legovini <pl@ninthfloor.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 08 Nov 2018 21:26:25 +0100
In-Reply-To: <2024dc2e-fb2d-2866-141e-78044d3ccba2@ninthfloor.org>
References: <2024dc2e-fb2d-2866-141e-78044d3ccba2@ninthfloor.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

> The attached patch adds support for CPPFLAGS to iw's Makefile.

Please send the patch as plain text (not attachment), and with signed-
off-by per the CONTRIBUTING file.

Thanks,
johannes


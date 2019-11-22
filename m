Return-Path: <SRS0=Y0IC=ZO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42381C432C0
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Nov 2019 12:08:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 227D720679
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Nov 2019 12:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbfKVMI4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Nov 2019 07:08:56 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:44426 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfKVMI4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Nov 2019 07:08:56 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iY7k6-0002e7-Or; Fri, 22 Nov 2019 13:08:55 +0100
Message-ID: <d1196ea09cf3024e352241353ad65e558d0c9393.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211_hwsim: support parent TSF feature
From:   Johannes Berg <johannes@sipsolutions.net>
To:     James Prestwood <prestwoj@gmail.com>,
        linux-wireless@vger.kernel.org
Date:   Fri, 22 Nov 2019 13:08:53 +0100
In-Reply-To: <20191119221541.11422-1-prestwoj@gmail.com> (sfid-20191119_231837_748319_729ACA97)
References: <20191119221541.11422-1-prestwoj@gmail.com>
         (sfid-20191119_231837_748319_729ACA97)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Please split this patch. The only thing actually related to what your
commit log mentions is the first part setting the nl80211 feature bit.

The rest is just porting some existing code to the wmediumd code path.

johannes


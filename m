Return-Path: <SRS0=jb13=W2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C9C6C3A5A4
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Aug 2019 10:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 495B021897
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Aug 2019 10:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbfH3KiY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 30 Aug 2019 06:38:24 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:34584 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727417AbfH3KiY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Aug 2019 06:38:24 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.1)
        (envelope-from <johannes@sipsolutions.net>)
        id 1i3eIP-0003zo-6c; Fri, 30 Aug 2019 12:38:21 +0200
Message-ID: <766f6d196106fa7ca6036b2ce20243e042d9168d.camel@sipsolutions.net>
Subject: Re: [PATCH v6] mac80211_hwsim: Register support for HE meshpoint
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sven Eckelmann <sven@narfation.org>, Jouni Malinen <j@w1.fi>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 30 Aug 2019 12:38:20 +0200
In-Reply-To: <3127506.552nsDcnha@bentobox> (sfid-20190813_132058_302926_3B8DB390)
References: <20190813063657.7544-1-sven@narfation.org>
         <20190813105549.GA26160@w1.fi> <3127506.552nsDcnha@bentobox>
         (sfid-20190813_132058_302926_3B8DB390)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

> > mesh_secure_ocv_mix_legacy
> > wpas_mesh_open_ht40
> > mesh_secure_ocv_mix_ht

> No, these also failed for me without the mac80211_hwsim patch [3] in a full 
> test run. And thus not analyzed further by me.

I also see these fail if (and only if) I have this patch applied.

I'm going to drop this patch (again) for now, even if the situation is
now better I still don't want to knowingly break things there.

Please resend once that's all sorted out.

johannes



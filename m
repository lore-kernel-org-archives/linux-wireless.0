Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF2FC282CE
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 07:27:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E61BC20880
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 07:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfDIH1j (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 03:27:39 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:44268 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfDIH1j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 03:27:39 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hDlAO-0003An-MB; Tue, 09 Apr 2019 09:27:36 +0200
Message-ID: <7deebb8e8c82e4455af8fc4963ffc7acca3aab36.camel@sipsolutions.net>
Subject: Re: linux-next: manual merge of the mac80211-next tree with the
 mac80211 tree
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Wireless <linux-wireless@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Date:   Tue, 09 Apr 2019 09:27:35 +0200
In-Reply-To: <20190409110607.29df3cf3@canb.auug.org.au>
References: <20190409110607.29df3cf3@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Stephen,

> Today's linux-next merge of the mac80211-next tree got a conflict in:
> 
>   net/mac80211/tx.c
> 
> between commit:
> 
>   eb9b64e3a9f8 ("mac80211: fix memory accounting with A-MSDU aggregation")
> 
> from the mac80211 tree and commit:
> 
>   dcec1d9bc8a7 ("mac80211: calculate hash for fq without holding fq->lock in itxq enqueue")
> 
> from the mac80211-next tree.

Thanks for the heads-up!

But yes, I'm aware. It seemed simple enough though that I decided to
keep it like that, I didn't really find a better solution.

johannes


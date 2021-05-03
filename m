Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0ED0C433B4
	for <linux-wireless@archiver.kernel.org>; Mon,  3 May 2021 16:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A01F61182
	for <linux-wireless@archiver.kernel.org>; Mon,  3 May 2021 16:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhECQSH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 May 2021 12:18:07 -0400
Received: from mx3.wp.pl ([212.77.101.10]:4270 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231150AbhECQSH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 May 2021 12:18:07 -0400
Received: (wp-smtpd smtp.wp.pl 18097 invoked from network); 3 May 2021 18:10:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1620058232; bh=8XGMuOBeACwEZMaYGesUMGBNwiLNiNz4H3wfdfgzzwU=;
          h=From:To:Cc:Subject;
          b=Qa3B+RxHIksrBt+KGFLhksmE7j49UlPumqfx+pf1iAdp0wLw9BF/5d57pSNQE5aFj
           jxZkA1l/onJo3jZMXu17+xxR6jTb6B5Wcxskf01a3biykzWQPfmzuKIr5WK4K3psFl
           aZMOiiTFoukLWJb0+MnCFqYmZ4WbPdyR1rr16PZQ=
Received: from unknown (HELO kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com) (kubakici@wp.pl@[163.114.132.4])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <sdlyyxy@bupt.edu.cn>; 3 May 2021 18:10:32 +0200
Date:   Mon, 3 May 2021 09:10:25 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Yan Xinyu <sdlyyxy@bupt.edu.cn>
Cc:     kvalo@codeaurora.org, davem@davemloft.net, matthias.bgg@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt7601u: Add support for Baidu Nuomi dongle
Message-ID: <20210503091025.64797075@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210503084735.78974-1-sdlyyxy@bupt.edu.cn>
References: <20210503084735.78974-1-sdlyyxy@bupt.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 16ae4f722a5b67e65c97582037b71b81
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [oQLj]                               
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon,  3 May 2021 16:47:35 +0800 Yan Xinyu wrote:
> Add VID/PID for Baidu Nuomi USB WiFi dongle
> 
> Signed-off-by: Yan Xinyu <sdlyyxy@bupt.edu.cn>

Acked-by: Jakub Kicinski <kuba@kernel.org>

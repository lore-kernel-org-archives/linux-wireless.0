Return-Path: <SRS0=BG2g=C6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E01D8C43469
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Sep 2020 16:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA3102223E
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Sep 2020 16:59:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wp.pl header.i=@wp.pl header.b="UGtNTtqV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730293AbgIUQ7I (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Sep 2020 12:59:08 -0400
Received: from mx3.wp.pl ([212.77.101.10]:37713 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729688AbgIUQ6r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Sep 2020 12:58:47 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 12:58:46 EDT
Received: (wp-smtpd smtp.wp.pl 13450 invoked from network); 21 Sep 2020 18:52:04 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1600707124; bh=pS0s86wtkZkGCWMQlTJztTBVhkWnFMCqOcJVff4yuvc=;
          h=From:To:Cc:Subject;
          b=UGtNTtqVtarl+XyGa2kB6cBeaa1BuI25AzUDueNTQn4DfiC1reVPXnlraaiDLYdr+
           Mp8omSuKlE4ifX0O4Jiiqe8mTv+MN7VJqtyabyr7ALqCuG9atTQPpQSiXK8s6oYJyH
           +dXpaI2dL/GQhV/9FxwiRa+lZLaUqcoWKiCFFLE0=
Received: from unknown (HELO kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com) (kubakici@wp.pl@[163.114.132.4])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <miaoqinglang@huawei.com>; 21 Sep 2020 18:52:04 +0200
Date:   Mon, 21 Sep 2020 09:51:57 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Qinglang Miao <miaoqinglang@huawei.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next v2] mt7601u: Convert to DEFINE_SHOW_ATTRIBUTE
Message-ID: <20200921095157.2cd0414e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200919024838.14172-1-miaoqinglang@huawei.com>
References: <20200919024838.14172-1-miaoqinglang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: e1ebc130c8383d7528f1935eea539bf8
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [gbJj]                               
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 19 Sep 2020 10:48:38 +0800 Qinglang Miao wrote:
> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
> 
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>

Acked-by: Jakub Kicinski <kubakici@wp.pl>

You can keep my ack. 

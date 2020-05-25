Return-Path: <SRS0=BuOi=7H=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB7FC433E0
	for <linux-wireless@archiver.kernel.org>; Mon, 25 May 2020 15:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 356A42078B
	for <linux-wireless@archiver.kernel.org>; Mon, 25 May 2020 15:03:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wp.pl header.i=@wp.pl header.b="wl6e2hHC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403996AbgEYPDg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 May 2020 11:03:36 -0400
Received: from mx4.wp.pl ([212.77.101.11]:7072 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390921AbgEYPDg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 May 2020 11:03:36 -0400
Received: (wp-smtpd smtp.wp.pl 483 invoked from network); 25 May 2020 17:03:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1590419013; bh=CDvSQ6BrcCrB4ZGfVwXXD8+My2voHzXif8dwKd0wEXA=;
          h=From:To:Cc:Subject;
          b=wl6e2hHCfCFB+wbg9V4ImdC8huMHMl4gOuvBqDOVHCa6P3U0LSwyv6gjfjgapSwlQ
           UxmVckpjt609+URF/00ZeU1KhDjb6tR+CrAAuvCgLH/bn8Xu//AeDFS1vNKdxImCYv
           RE/KeU41qxOnyl/O1zcHLjlWiYY/NJjXch1tPhr0=
Received: from unknown (HELO localhost) (stf_xl@wp.pl@[46.39.164.203])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <rsalvaterra@gmail.com>; 25 May 2020 17:03:33 +0200
Date:   Mon, 25 May 2020 17:03:17 +0200
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     Rui Salvaterra <rsalvaterra@gmail.com>
Cc:     johannes@sipsolutions.net, julian.calaby@gmail.com,
        kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] rt2800: enable MFP support unconditionally
Message-ID: <20200525150317.GA928949@wp.pl>
References: <20200525134906.1672-1-rsalvaterra@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525134906.1672-1-rsalvaterra@gmail.com>
X-WP-MailID: b382c167147dcde73ed55a0a35f4e7b7
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [0RNE]                               
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, May 25, 2020 at 02:49:07PM +0100, Rui Salvaterra wrote:
> v2: fixed null pointer.

This should go after --- , but not need to resend patch, Kalle kindly
fixes that for us in the patchwork.

> This gives us WPA3 support out of the box without having to manually disable
> hardware crypto. The driver will fall back to software crypto if the connection
> requires management frame protection.
> 
> Suggested-by: Stanislaw Gruszka <stf_xl@wp.pl>
> Signed-off-by: Rui Salvaterra <rsalvaterra@gmail.com>

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

Thanks!

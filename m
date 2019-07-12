Return-Path: <SRS0=USiB=VJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09AF2C742D2
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Jul 2019 17:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B067820665
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Jul 2019 17:35:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wp.pl header.i=@wp.pl header.b="kPumlpbT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727371AbfGLRfx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Jul 2019 13:35:53 -0400
Received: from mx4.wp.pl ([212.77.101.12]:48169 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbfGLRfx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Jul 2019 13:35:53 -0400
Received: (wp-smtpd smtp.wp.pl 4437 invoked from network); 12 Jul 2019 19:35:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1562952949; bh=SZvmqy3oUCVdhe0NhWrmQnjIKbcv/GAmPZ9lecMbgD4=;
          h=From:To:Cc:Subject;
          b=kPumlpbTxRJvEIIrAXNxB0m3W8FCJBB9oVZMK9c5914lmpdYeGVkM4eGMGSsjAUgP
           kBsx2GS5VDST5UFgy8nfvaBHb11/x9Be9g9IVo8tWPc/yQ/GUPtEnzvcPGLcQAQ8T5
           GktVhfNtws4R1BBTfZnDN7CIWS5jMD9/CIIA9CkM=
Received: from 014.152-60-66-biz-static.surewest.net (HELO cakuba.netronome.com) (kubakici@wp.pl@[66.60.152.14])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <sgruszka@redhat.com>; 12 Jul 2019 19:35:49 +0200
Date:   Fri, 12 Jul 2019 10:35:44 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt7601u: use params->ssn value directly
Message-ID: <20190712103544.5291726f@cakuba.netronome.com>
In-Reply-To: <20190712120949.GA21396@redhat.com>
References: <20190712120949.GA21396@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: e19cb32d6fe89780bbad1e587fad1a3b
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [kVP0]                               
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 12 Jul 2019 14:09:50 +0200, Stanislaw Gruszka wrote:
> There is no point to use pointer to params->ssn.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Jakub Kicinski <kubakici@wp.pl>

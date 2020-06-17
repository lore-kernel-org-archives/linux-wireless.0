Return-Path: <SRS0=BEmV=76=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45916C433E1
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Jun 2020 16:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 077332098B
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Jun 2020 16:59:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nic.cz header.i=@nic.cz header.b="rlje6GgR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgFQQ7P (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Jun 2020 12:59:15 -0400
Received: from lists.nic.cz ([217.31.204.67]:52432 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgFQQ7P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jun 2020 12:59:15 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 19A0F140641;
        Wed, 17 Jun 2020 18:59:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1592413153; bh=cWkt2xSVrdiEy1s6iOoocNP+lewGcSDGwRJhEbkh2Qk=;
        h=Date:From:To;
        b=rlje6GgRguakldTCYOCUiI4zq6OpcmoSvNKmhHA5m+cIqJx2NViZFWmnbM0uLI3tc
         R/x0s5L0Kyr7jTNYZGU/rbSLQ/AketPhpbn/XsHYJa5mbcchPHsa6vT2vK0fqwGPyS
         HWqoe99d/z/PAJNC3Ni2V6WQ5Nk1J8O0ndfjqclU=
Date:   Wed, 17 Jun 2020 18:59:12 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Ryder Lee <ryder.lee@mediatek.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        <linux-wireless@vger.kernel.org>
Subject: mediatek mt7915 status and devices?
Message-ID: <20200617185912.631766ff@nic.cz>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

what is the current status of this driver? Is it already usable as a
stable AP for 802.11ax?

And are there some WiFi cards utilizing this chipset? We would like to
look into this for the Turris routers.

Marek

Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2738C10F00
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 15:24:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B875D20878
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 15:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550849077;
	bh=6ZBWeQrq0omWjhvkX/VcYRQq12nSAuDp42HcHKe+8Io=;
	h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
	 List-ID:From;
	b=oiAtFEBzEKZHvnGzN4zLDVP7rb/uBHZLXv5BIGI8zkasEvp+PG4+5E/3fi8/yQzAJ
	 hjzZrFZ3Uch0v64DatBp73598swTrnrL90Zs2T6AWm0/UJywiAGTFJujplh1TA8caT
	 ZR0pmoN2I6C33d9CCFzp4YPU2Vhxvjn2tARtEYaE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfBVPYh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 10:24:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:51172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbfBVPYh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 10:24:37 -0500
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 378512086C;
        Fri, 22 Feb 2019 15:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550849076;
        bh=6ZBWeQrq0omWjhvkX/VcYRQq12nSAuDp42HcHKe+8Io=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=xy//mL6rUOibf5qcYzL0ujUNmp93dg2BJ5tY6G6uE1Jl3lGSTBTejkQmGnaRzQ7Vv
         bM5e0bnQMiUBYEUwwdJJvRChgOaNuVbsD156oYvxOKJp26Fr6UQTJ0GBx0oB5QCzjQ
         OQh27UQxlK0B/NueF7ViGSOTx1RzSwxymRDqucck=
Date:   Fri, 22 Feb 2019 15:24:35 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/4] mt76: fix corrupted software generated tx CCMP PN
In-Reply-To: <20190218194218.41314-2-nbd@nbd.name>
References: <20190218194218.41314-2-nbd@nbd.name>
Message-Id: <20190222152436.378512086C@mail.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 23405236460b mt76: fix transmission of encrypted management frames.

The bot has tested the following trees: v4.20.11, v4.19.24.

v4.19.24: Failed to apply! Possible dependencies:
    047aed1c38cf ("mt76: unify mac_shared_key_setup")
    108a4861ef19 ("mt76: create new mt76x02-lib module for common mt76x{0,2} code")
    2735a6dd7df3 ("mt76: unify wait_for_mac")
    32bb405fe2bc ("mt76: unify mac_wcid_setup")
    427f9ebec682 ("mt76: move mt76x02_mac_write_txwi in mt76x02-lib module")
    46436b5ef9dd ("mt76: unify mac_wcid_set_key")
    516ea2a2a9d4 ("mt76: use mac_wcid_set_drop in mt76x0")
    797ea2407825 ("mt76: merge mt76x0/regs.h into mt76x02_regs.h")
    c378f2473466 ("mt76: unify mac_get_key_info")
    f5a7f126e5fe ("mt76: unify sta structure part 1")


How should we proceed with this patch?

--
Thanks,
Sasha

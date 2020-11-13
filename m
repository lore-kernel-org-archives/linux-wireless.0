Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00DF7C55ABD
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Nov 2020 15:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD4CA22201
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Nov 2020 15:47:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="YD5wORF9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgKMPrd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 13 Nov 2020 10:47:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:56298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726915AbgKMPra (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Nov 2020 10:47:30 -0500
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7CD6208D5;
        Fri, 13 Nov 2020 15:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605282449;
        bh=WucMBtEoa/AlY6k3+2+WeXvXU7TxcfAlNWSUqzd9pD0=;
        h=Date:From:To:Cc:Subject:From;
        b=YD5wORF9nErCDO7IuxYw9dY1K9ATCOLZwf91h1OAlkrk5n3BznofeH5Qi0rGPDlD3
         xMtWowJGJEc0gu1hb9xmJ2pQP/n1tiudgqZ9taBbeAkAJJA6HjG30O9SgjTS+NtqlN
         EBSgxxe8FzWAYVTQkaGtvSWxodqK4pVembKOH1NE=
Received: by pali.im (Postfix)
        id 28BF1723; Fri, 13 Nov 2020 16:47:27 +0100 (CET)
Date:   Fri, 13 Nov 2020 16:47:27 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>
Cc:     linux-wireless@vger.kernel.org, linux-firmware@vger.kernel.org,
        Marek =?utf-8?B?QmVow7pu?= <marek.behun@nic.cz>
Subject: New firmware 16.68.10.p56 for mwifiex 88W8997 SDIO wifi chip
Message-ID: <20201113154727.ndk5pcijd2qdvrrf@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Ganapathi,

there is a new firmware version 16.68.10.p56 for 88W8997 SDIO wifi chip.
Current version of firmware file sdsd8997_combo_v4.bin for this chip in
linux-firmware repository is 16.68.1.p197:

https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/log/mrvl/sdsd8997_combo_v4.bin

Ganapathi, could you please send an update for this firmware file?

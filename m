Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49117 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2BNS35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 13:29:57 -0500
Received: by pbcun15 with SMTP id un15so665363pbc.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2012 10:29:57 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20282.43026.335779.405152@gargle.gargle.HOWL> (sfid-20120214_193001_376240_C4EC2B6B)
Date: Tue, 14 Feb 2012 23:59:38 +0530
To: Ben Greear <greearb@candelatech.com>
Cc: ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [ath9k-devel] [PATCH 3/7] ath9k: Merge wiphy and misc debugfs files
In-Reply-To: <4F3A9ACB.3010009@candelatech.com>
References: <20280.43962.403799.188541@gargle.gargle.HOWL>
	<4F3947A1.2060103@candelatech.com>
	<20281.48485.409968.741657@gargle.gargle.HOWL>
	<4F39BF5F.3030408@candelatech.com>
	<20281.52354.478076.479135@gargle.gargle.HOWL>
	<20120214073855.6843.qmail@stuge.se>
	<20282.7088.898987.229335@gargle.gargle.HOWL>
	<4F3A9ACB.3010009@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> Actually, I think it might be useful to have a second level of debugging.
> I hope to soon have time & resources to add some logic to dump lots of register
> info and such in human-readable format, (like, when DMA times out).  That is going to be a lot
> of strings added to the driver, so the compile size will definitely
> increase.  If keeping the size small is important, then this sort of verbose thing
> could be hidden behind a second level of debugging...

That could be implemented similar to what usbmon does. A debugfs file that could
be read and redirected to a file. And there would be no overhead to the
driver, I think. We could call it the 'event log'. :)

Sujith

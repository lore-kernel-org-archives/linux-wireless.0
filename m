Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:36096 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbbAaCD3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 21:03:29 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21708.14493.458370.65799@gargle.gargle.HOWL> (sfid-20150131_030332_364226_C77D568C)
Date: Sat, 31 Jan 2015 07:36:21 +0530
To: Peter Oh <poh@codeaurora.org>
Cc: Bob Copeland <me@bobcopeland.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	Peter Oh <poh@qca.qualcomm.com>
Subject: Re: [PATCH] ath10k: Replace ioread with wmb for data sync
In-Reply-To: <54CC3640.2090209@codeaurora.org>
References: <1422311118-11320-1-git-send-email-poh@qca.qualcomm.com>
	<20150127213349.GA24933@localhost>
	<54C824DC.5080804@qca.qualcomm.com>
	<20150128043005.GB24933@localhost>
	<54C875FD.3070101@qca.qualcomm.com>
	<1422430643.1973.1.camel@sipsolutions.net>
	<54CC0B71.9050301@codeaurora.org>
	<21708.11481.380046.994311@gargle.gargle.HOWL>
	<54CC3640.2090209@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh wrote:
> Please refer the email thread that I mentioned about other architectures.
> (dsb is for ARM and other platforms have the equivalent instruction such 
> as sfence, sync, mf, and dcs).

Ok.

> Also the patch is updated with 2nd patch set replacing wmb to mb.

Would be good to test this on a MIPS platform...

Sujith

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:54074 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbbAaBNT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 20:13:19 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21708.11481.380046.994311@gargle.gargle.HOWL> (sfid-20150131_021322_800648_EF2DBBBD)
Date: Sat, 31 Jan 2015 06:46:09 +0530
To: Peter Oh <poh@codeaurora.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Peter Oh <poh@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
	ath10k@lists.infradead.org
Subject: Re: [PATCH] ath10k: Replace ioread with wmb for data sync
In-Reply-To: <54CC0B71.9050301@codeaurora.org>
References: <1422311118-11320-1-git-send-email-poh@qca.qualcomm.com>
	<20150127213349.GA24933@localhost>
	<54C824DC.5080804@qca.qualcomm.com>
	<20150128043005.GB24933@localhost>
	<54C875FD.3070101@qca.qualcomm.com>
	<1422430643.1973.1.camel@sipsolutions.net>
	<54CC0B71.9050301@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh wrote:
> As I addressed wmb uses dsb (in arm arch) and here is the description of 
> arm architecture.

What about other architectures ?

Sujith

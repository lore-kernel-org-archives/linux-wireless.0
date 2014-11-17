Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:34347 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaKQLw0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2014 06:52:26 -0500
From: Sujith Manoharan <sujith@msujith.org>
Message-ID: <21609.57811.107846.718878@gargle.gargle.HOWL> (sfid-20141117_125230_160559_02BF5714)
Date: Mon, 17 Nov 2014 17:23:55 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Block radar events when requested
In-Reply-To: <CA+BoTQkpqVKVHFoXuTJtkTmFZA0XfU56nLRaVegWUr29z83_tQ@mail.gmail.com>
References: <1416209393-24736-1-git-send-email-sujith@msujith.org>
	<CA+BoTQkpqVKVHFoXuTJtkTmFZA0XfU56nLRaVegWUr29z83_tQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior wrote:
> The simulate_radar knob is meant to be used with
> dfs_block_radar_events being true in the first place so you can easily
> block real DFS events and inject fake ones for testing of DFS upper
> layers with ath10k.
> 
> Your patch breaks this. Why would you want to do that?

Apparently, this knob is also being used to make sure that
radar detection doesn't happen when NOL is disabled.

I'll check if this test case is needed at all before
adding another knob to the existing pile...

Sujith

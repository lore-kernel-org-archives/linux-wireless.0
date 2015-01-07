Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:43507 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576AbbAGAn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 19:43:58 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21676.33246.233235.411880@gargle.gargle.HOWL> (sfid-20150107_014404_994020_8A09D6C8)
Date: Wed, 7 Jan 2015 06:16:22 +0530
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH 0/5] ath9k patches
In-Reply-To: <87a91vzt3t.fsf@kamboji.qca.qualcomm.com>
References: <1418951039-12309-1-git-send-email-sujith@msujith.org>
	<87a91vzt3t.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> What are the dependency patches exactly?

commit 5cf16616e152dd5c274a65954c77f64892d025a8
Author: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Date:   Wed Dec 10 21:26:11 2014 +0530

    mac80211: Fix accounting of multicast frames

commit 6b127c71fbdd3daacfd8b9f80b8e6ebfb70a889e
Author: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Date:   Wed Dec 10 21:26:10 2014 +0530

    mac80211: Move IEEE80211_TX_CTL_PS_RESPONSE

Sujith

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:38073 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbbAMUyV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 15:54:21 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21685.34425.956271.56227@gargle.gargle.HOWL> (sfid-20150113_215436_988385_A9869131)
Date: Wed, 14 Jan 2015 02:26:25 +0530
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Make HTT fill size configurable
In-Reply-To: <87zj9m4u5h.fsf@kamboji.qca.qualcomm.com>
References: <1420432796-10765-1-git-send-email-sujith@msujith.org>
	<CA+BoTQ=HqF0vBj4chXfoY9GKcFBP8Xh37HXo5etDDZ1XCg6O4w@mail.gmail.com>
	<21677.3195.451116.244389@gargle.gargle.HOWL>
	<87zj9m4u5h.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> > I tried that earlier and could see only marginal improvement. The biggest
> > increase came when I replaced netif_receive_skb() with netif_rx()
> > in mac80211/rx.c.
> 
> Any ideas why that increases throughput?

Not sure, but RPS is enabled by default on this platform,
so maybe that influences something...

Sujith

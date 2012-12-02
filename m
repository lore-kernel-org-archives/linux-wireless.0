Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:5798 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab2LBIOT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2012 03:14:19 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Kalle Valo <kvalo@adurom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>, Jason Baron <jbaron@redhat.com>
Subject: Re: [RFC] How to manage dependency between patches
Date: Sun, 2 Dec 2012 10:14:07 +0200
Message-ID: <4690706.ontQQdo20b@lx-vladimir> (sfid-20121202_091523_608887_8C73CAB5)
In-Reply-To: <20121201023800.GD2355@tuxdriver.com>
References: <1352978222-13866-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1585902.GCBvcuyASu@lx-vladimir> <20121201023800.GD2355@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, November 30, 2012 09:38:00 PM John W. Linville wrote:
> Since Greg is merging one patch and I'm merging the other, under
> normal circumstances they will only reach the same tree sometime
> during the 3.8 merge window.  FWIW, I was under the impression that
> you were targeting 3.9 anyway.  If so, you can simply wait to have
> your driver merged sometime after 3.8-rc1.
> 
> Does that help?
> 
> John
> 

Thanks John,

Actually, I was after 3.8; but I understand in my situation it may be
not feasible.

Positive side is till 3.9 I can integrate more features;
negative one is... the same - since I will end up with one bulky patch.

I'd actually prefer to have baseline merged, and then submit 'feature'
patches - it will be easier to review.

By the way - what is better, hold new features till initial driver merged,
or keep integrating more and more stuff?

Thanks, Vladimir



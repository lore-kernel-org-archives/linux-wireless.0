Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:10623 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3CEHUz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 02:20:55 -0500
Cc: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	<ath6kl-devel@qca.qualcomm.com>
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Subject: Re: [PATCH 2/2] ath6kl: provide 64-bit per-station byte counters
References: <1359978792-7121-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1359978792-7121-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Tue, 5 Mar 2013 09:20:48 +0200
In-Reply-To: <1359978792-7121-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
	(Vladimir Kondratiev's message of "Mon, 4 Feb 2013 13:53:12 +0200")
Message-ID: <87vc96gvn3.fsf@kamboji.qca.qualcomm.com> (sfid-20130305_082059_121267_89226D4A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com> writes:

> Internally, 64-bit byte counters maintained for per-station
> statistics. Tell to the netlink that full 64-bit value provided
>
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

John already applied this patch so I can skip it.

-- 
Kalle Valo

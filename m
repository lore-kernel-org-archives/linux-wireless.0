Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23409 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbbJELXe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 07:23:34 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Geliang Tang <geliangtang@163.com>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: drop unlikely behind WARN_ON()
References: <88184946efc981b4cba84cf21418954423ca11a4.1443942486.git.geliangtang@163.com>
	<1444027933.1875.0.camel@sipsolutions.net>
Date: Mon, 5 Oct 2015 14:23:18 +0300
In-Reply-To: <1444027933.1875.0.camel@sipsolutions.net> (Johannes Berg's
	message of "Mon, 5 Oct 2015 08:52:13 +0200")
Message-ID: <87si5p4l09.fsf@kamboji.qca.qualcomm.com> (sfid-20151005_132349_185881_B3D92112)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> The subject is entirely wrong - this is not a cfg80211 patch.

Yes, please use prefix "ath6kl: ".

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54629 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbbJEGwW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 02:52:22 -0400
Message-ID: <1444027933.1875.0.camel@sipsolutions.net> (sfid-20151005_085244_807995_F3FA5567)
Subject: Re: [PATCH] cfg80211: drop unlikely behind WARN_ON()
From: Johannes Berg <johannes@sipsolutions.net>
To: Geliang Tang <geliangtang@163.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Mon, 05 Oct 2015 08:52:13 +0200
In-Reply-To: <88184946efc981b4cba84cf21418954423ca11a4.1443942486.git.geliangtang@163.com> (sfid-20151004_091053_059419_DD65FE71)
References: <88184946efc981b4cba84cf21418954423ca11a4.1443942486.git.geliangtang@163.com>
	 (sfid-20151004_091053_059419_DD65FE71)
Content-Type: text/plain
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The subject is entirely wrong - this is not a cfg80211 patch.

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35284 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758404Ab3DCMIk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 08:08:40 -0400
Message-ID: <1364990913.8351.19.camel@jlt4.sipsolutions.net> (sfid-20130403_140843_991100_4941070F)
Subject: Re: [PATCH] mac80211: fix the PREP mesh hwmp debug message
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org
Date: Wed, 03 Apr 2013 14:08:33 +0200
In-Reply-To: <1364982593-30977-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20130403_123020_621589_B850CD2D)
References: <1364982593-30977-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20130403_123020_621589_B850CD2D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-03 at 17:49 +0800, Chun-Yeow Yeoh wrote:
> The mesh hwmp debug message is a bit confusing. The "sending PREP
> to %p" should be the MAC address of mesh STA that has originated
> the PREQ message and the "received PREP from %pM" should be the MAC
> address of the mesh STA that has originated the PREP message.

Applied.

johannes


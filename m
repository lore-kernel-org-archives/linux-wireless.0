Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48390 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab2GZRyD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 13:54:03 -0400
Message-ID: <1343325238.4477.10.camel@jlt3.sipsolutions.net> (sfid-20120726_195408_388824_C070C846)
Subject: Re: [PATCH v1] cfg80211: unify IE search
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 26 Jul 2012 19:53:58 +0200
In-Reply-To: <1343213813-29568-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1343213813-29568-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-25 at 13:56 +0300, Vladimir Kondratiev wrote:
> Remove ah-hock IE search code found in the ieee80211_bss_get_ie()
> Use cfg80211_find_ie() instead.

Applied, thanks.

johannes


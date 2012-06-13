Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37826 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab2FML2V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 07:28:21 -0400
Message-ID: <1339586895.4519.33.camel@jlt3.sipsolutions.net> (sfid-20120613_132824_326377_F93F7166)
Subject: Re: [PATCH] cfg80211/nl80211: Fix for wireless-testing kernel crash
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 13 Jun 2012 13:28:15 +0200
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0A6BFE@mbx022-e1-nj-10.exch022.domain.local>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0A6BFE@mbx022-e1-nj-10.exch022.domain.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-13 at 11:15 +0000, Mahesh Palivela wrote:
> I saw wireless-testing kernel crash at nl80211 survey_dump function. we can see this crash only when run wpa_supplicant of hostap dev branch. This patch is fix for it.

Please break long lines, include information about the crash and why
this fixes it, and don't reference wireless-testing ... it's not
specific in that particular tree

Thanks.

johannes




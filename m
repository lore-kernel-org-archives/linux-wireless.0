Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36608 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab3JIHiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Oct 2013 03:38:24 -0400
Message-ID: <1381304297.14186.2.camel@jlt4.sipsolutions.net> (sfid-20131009_093827_237332_95887337)
Subject: Re: [PATCH] cfg80211: rename regulatory_hint_11d() to
 regulatory_hint_country_ie()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 09 Oct 2013 09:38:17 +0200
In-Reply-To: <1380935244-22612-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131005_030732_588539_9072AD69)
References: <1380935244-22612-1-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20131005_030732_588539_9072AD69)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-10-04 at 18:07 -0700, Luis R. Rodriguez wrote:
> It is incorrect to refer to this as 11d as 802.11d was just a
> proposed ammendment, 802.11d was merged to the standard so
> use proper terminology.

Applied.

johannes


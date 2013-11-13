Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45324 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab3KMSsQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 13:48:16 -0500
Message-ID: <1384368487.14578.25.camel@jlt4.sipsolutions.net> (sfid-20131113_194819_884058_77C03353)
Subject: Re: [RFC 0/5] cfg80211: regulatory quiescing and exporting DFS
 regions
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 13 Nov 2013 19:48:07 +0100
In-Reply-To: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131113_191303_487569_0D8B4A85)
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20131113_191303_487569_0D8B4A85)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-13 at 19:12 +0100, Luis R. Rodriguez wrote:

> Janusz, please test, and likely feel free to take on the last patch.
> We may need help from Johannes on the rtnl lock question now required
> for checks on enabling beacon operation.

What's that rtnl thing about?

johannes


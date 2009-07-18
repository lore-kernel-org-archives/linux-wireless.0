Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:36485 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbZGRMAf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jul 2009 08:00:35 -0400
Subject: Re: [PATCH] cfg80211: don't optimise wext calls too much
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1247737144.24433.11.camel@johannes.local>
References: <1247737144.24433.11.camel@johannes.local>
Content-Type: text/plain
Date: Sat, 18 Jul 2009 14:00:13 +0200
Message-Id: <1247918413.4549.81.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> In the wext code I tried to not reconnect all the time
> when the user wasn't really sure what they were doing,
> like setting the BSSID back to the same value it was.
> However, this optimisation should only be done while
> associated so that setting the BSSID back to the same
> value that it was actually triggers a new association
> if not currently associated. To achieve, that, put the
> relevant code into the !IDLE case instead.

this patch fixes my problems with wireless-testing.git

> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Tested-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel



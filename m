Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55753 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658Ab3I3O3b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 10:29:31 -0400
Message-ID: <1380551364.14467.13.camel@jlt4.sipsolutions.net> (sfid-20130930_162939_598653_BAC808AA)
Subject: Re: [PATCH 1/4] cfg80211: export reg_initiator_name()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Mon, 30 Sep 2013 16:29:24 +0200
In-Reply-To: <1379607490-18972-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20130919_181825_353097_F725FC3A)
References: <1379607490-18972-1-git-send-email-mcgrof@do-not-panic.com>
	 <1379607490-18972-2-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20130919_181825_353097_F725FC3A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-09-19 at 11:18 -0500, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> 
> Drivers can now use this to parse the regulatory request and
> be more verbose when needed.

Do drivers actually have to care about the initiator though?

johannes


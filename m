Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56476 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaDYPo3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 11:44:29 -0400
Message-ID: <1398440079.4152.20.camel@jlt4.sipsolutions.net> (sfid-20140425_174613_233608_659C47B8)
Subject: Re: [PATCH 10/12] mac80211: change return value of notifier function
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 25 Apr 2014 17:34:39 +0200
In-Reply-To: <7336424bc39404833509efc7fc9bf0ba0af450f1.1398055854.git.gamerh2o@gmail.com> (sfid-20140421_065524_383592_95172171)
References: <cover.1398055853.git.gamerh2o@gmail.com>
	 <7336424bc39404833509efc7fc9bf0ba0af450f1.1398055854.git.gamerh2o@gmail.com>
	 (sfid-20140421_065524_383592_95172171)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-04-21 at 12:53 +0800, Zhao, Gang wrote:
> Return NOTIFY_DONE if we don't care this time's notification, return
> NOTIFY_OK if we successfully handled this time's notification. That's
> the formal way to do it.

Same here.

johannes


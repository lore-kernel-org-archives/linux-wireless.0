Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41132 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932395AbaEEN47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2014 09:56:59 -0400
Message-ID: <1399298205.22235.16.camel@jlt4.sipsolutions.net> (sfid-20140505_155702_350411_E511B7DE)
Subject: Re: [PATCH 1/2] mac80211: set an external flag for TDLS stations
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 05 May 2014 15:56:45 +0200
In-Reply-To: <1398928648-5052-1-git-send-email-arik@wizery.com> (sfid-20140501_091735_648487_D9751C96)
References: <1398928648-5052-1-git-send-email-arik@wizery.com>
	 (sfid-20140501_091735_648487_D9751C96)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-01 at 10:17 +0300, Arik Nemtsov wrote:
> expose a new tdls flag for the public ieee80211_sta struct. This is used
> in some rate control decisions.

Applied both.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35360 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbbBWW2o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 17:28:44 -0500
Message-ID: <1424730522.1899.7.camel@sipsolutions.net> (sfid-20150223_232847_152681_040049AB)
Subject: Re: [PATCH] mac80211: use rhashtable for station table
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date: Mon, 23 Feb 2015 23:28:42 +0100
In-Reply-To: <1424729466-13380-1-git-send-email-johannes@sipsolutions.net> (sfid-20150223_231114_751056_B7210C06)
References: <1424729466-13380-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20150223_231114_751056_B7210C06)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Err, well, I need to rebase this patch on the changed rhashtable APIs in
net-next :) WIP.

johannes


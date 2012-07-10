Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39008 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab2GJQHk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 12:07:40 -0400
Message-ID: <1341936456.4475.25.camel@jlt3.sipsolutions.net> (sfid-20120710_180744_117236_6B449E09)
Subject: Re: [PATCH 1/2] mac80211: restructure key selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 10 Jul 2012 18:07:36 +0200
In-Reply-To: <1341418208-28663-1-git-send-email-cavallar@lri.fr>
References: <1341408545.12432.10.camel@jlt3.sipsolutions.net>
	 <1341418208-28663-1-git-send-email-cavallar@lri.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Applied both. I think we need to figure out more of the story with
drop_unencrypted and why we say we don't want to encrypt BA action
frames?!

johannes


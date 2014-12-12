Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33201 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967475AbaLLMk6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 07:40:58 -0500
Message-ID: <1418388050.2470.33.camel@sipsolutions.net> (sfid-20141212_134101_600502_0695D83E)
Subject: Re: [PATCH v8 4/4] cfg80211: correctly check ad-hoc channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Date: Fri, 12 Dec 2014 13:40:50 +0100
In-Reply-To: <1417622897-30768-4-git-send-email-arik@wizery.com> (sfid-20141203_170821_596531_3A3BC82C)
References: <1417622897-30768-1-git-send-email-arik@wizery.com>
	 <1417622897-30768-4-git-send-email-arik@wizery.com>
	 (sfid-20141203_170821_596531_3A3BC82C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-03 at 18:08 +0200, Arik Nemtsov wrote:
> Ad-hoc requires beaconing for regulatory purposes. Validate that the
> channel is valid for beaconing, and not only enabled.

Applied.

johannes


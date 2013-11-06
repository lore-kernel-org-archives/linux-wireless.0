Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43066 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab3KFKgB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 05:36:01 -0500
Message-ID: <1383734156.14307.24.camel@jlt4.sipsolutions.net> (sfid-20131106_113605_060485_0EE72148)
Subject: Re: [PATCH 01/17] mac80211: fix off-by-one in llid check.
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Date: Wed, 06 Nov 2013 11:35:56 +0100
In-Reply-To: <1383679025-7150-1-git-send-email-thomas@cozybit.com> (sfid-20131105_202241_113940_67252DB1)
References: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
	 (sfid-20131105_202241_113940_67252DB1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Very nice. I've squashed the llid assignment into the patch that
introduced the warning.

johannes


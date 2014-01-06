Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43785 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbaAFTLZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 14:11:25 -0500
Message-ID: <1389035483.5891.43.camel@jlt4.sipsolutions.net> (sfid-20140106_201127_671824_2E4D31F1)
Subject: Re: [PATCH v3 2/2] mac80211: sync dtim_count to TSF
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <twpedersen@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Date: Mon, 06 Jan 2014 20:11:23 +0100
In-Reply-To: <1387477515-3583-2-git-send-email-twpedersen@gmail.com> (sfid-20131219_192632_987010_6A31AF09)
References: <1387477515-3583-1-git-send-email-twpedersen@gmail.com>
	 <1387477515-3583-2-git-send-email-twpedersen@gmail.com>
	 (sfid-20131219_192632_987010_6A31AF09)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-19 at 10:25 -0800, Thomas Pedersen wrote:
> On starting a mesh or AP BSS, the interface dtim_count
> countdown should match that of the driver TSF.

Applied, though I think it's futile to really try to do this without
supporting multiple TSF timers :)

johannes


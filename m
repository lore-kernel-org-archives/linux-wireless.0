Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54889 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab0CXFt2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 01:49:28 -0400
Subject: Re: [PATCH 1/2] mac80211: support paged rx SKBs
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1269399463-5244-1-git-send-email-yi.zhu@intel.com>
References: <1269399463-5244-1-git-send-email-yi.zhu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Mar 2010 22:49:05 -0700
Message-ID: <1269409745.5149.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-24 at 10:57 +0800, Zhu Yi wrote:
> Mac80211 drivers can now pass paged SKBs to mac80211 via
> ieee80211_rx{_irqsafe}. The implementation currently use
> skb_linearize() in a few places i.e. management frame handling,
> software decryption, defragmentation and A-MSDU process. We can
> optimize them one by one later.


Cool, thanks, I'll go over it in the morning to double-check you caught
all the places :)

johannes


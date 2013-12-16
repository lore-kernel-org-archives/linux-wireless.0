Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41192 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab3LPMq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 07:46:58 -0500
Message-ID: <1387198012.4665.24.camel@jlt4.sipsolutions.net> (sfid-20131216_134700_951947_70772EE5)
Subject: Re: [PATCH] mac80211: make ieee80211_assign_beacon() static
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 16 Dec 2013 13:46:52 +0100
In-Reply-To: <1386488545-15901-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1386488545-15901-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-12-08 at 09:42 +0200, Emmanuel Grumbach wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> This function is not used anywhere else than in cfg.c, so there's no
> need to export it.

Applied.

johannes


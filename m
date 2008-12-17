Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53586 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbYLQPpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 10:45:18 -0500
Date: Wed, 17 Dec 2008 10:35:25 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	mabbaswireless@gmail.com
Subject: Re: [PATCH v2 1/3] cfg80211: add PM hooks
Message-ID: <20081217153524.GA3539@tuxdriver.com> (sfid-20081217_164524_845516_CF574A4F)
References: <1229313039-5544-2-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1229313039-5544-2-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 14, 2008 at 10:50:37PM -0500, Bob Copeland wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> 
> This should help implement suspend/resume in mac80211, these
> hooks will be run before the device is suspended and after it
> resumes. Therefore, they can touch the hardware as much as
> they want to.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Is cfg80211 the right place for these?  Is it likely that any
non-mac80211 users of cfg80211 will ever want to use these hooks?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.

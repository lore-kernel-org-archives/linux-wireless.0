Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:58715 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbaANG14 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 01:27:56 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] mac80211: add tracing for ieee80211_sta_set_buffered
References: <1389006270-21768-1-git-send-email-johannes@sipsolutions.net>
Date: Tue, 14 Jan 2014 08:27:53 +0200
In-Reply-To: <1389006270-21768-1-git-send-email-johannes@sipsolutions.net>
	(Johannes Berg's message of "Mon, 6 Jan 2014 12:04:30 +0100")
Message-ID: <87ob3fnkly.fsf@purkki.adurom.net> (sfid-20140114_072800_240207_84377A2B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> This is useful for debugging issues with drivers using this
> function (erroneously), so add tracing for the API call.
>
> Change-Id: Ice9d7eabb8fecbac188f0a741920d3488de700ec

Extra change id.

(Sending just in case you missed it)

-- 
Kalle Valo

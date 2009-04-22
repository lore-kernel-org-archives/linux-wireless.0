Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:53449 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbZDVTpx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 15:45:53 -0400
Received: by mail-fx0-f158.google.com with SMTP id 2so162414fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 22 Apr 2009 12:45:52 -0700 (PDT)
To: Bob Copeland <me@bobcopeland.com>
Cc: kalle.valo@nokia.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/6] wl12xx: update to 2.6.29 mac80211 hw scan API
References: <1238897428-19639-1-git-send-email-me@bobcopeland.com>
	<1238897428-19639-2-git-send-email-me@bobcopeland.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 22 Apr 2009 22:45:50 +0300
In-Reply-To: <1238897428-19639-2-git-send-email-me@bobcopeland.com> (Bob Copeland's message of "Sat\,  4 Apr 2009 22\:10\:23 -0400")
Message-ID: <87ocuoeakx.fsf@litku.valot.fi> (sfid-20090422_214555_420712_5A37BA1F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> The ops->hw_scan callback now takes a struct *cfg80211_scan_request,
> and the scan_completed notifier takes a parameter to indicate whether
> the scan was aborted.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

Applied.

-- 
Kalle Valo

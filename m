Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:53449 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZDVTqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 15:46:19 -0400
Received: by mail-fx0-f158.google.com with SMTP id 2so162414fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 22 Apr 2009 12:46:19 -0700 (PDT)
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/6] wl12xx: remove ssid parameters from driver private struct
References: <1238897428-19639-1-git-send-email-me@bobcopeland.com>
	<1238897428-19639-3-git-send-email-me@bobcopeland.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 22 Apr 2009 22:46:17 +0300
In-Reply-To: <1238897428-19639-3-git-send-email-me@bobcopeland.com> (Bob Copeland's message of "Sat\,  4 Apr 2009 22\:10\:24 -0400")
Message-ID: <87k55ceak6.fsf@litku.valot.fi> (sfid-20090422_214623_880872_BC3EACBB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> Since 2.6.29, mac80211 no longer passes ssid to the drivers and
> wl12xx doesn't need it anyway, so remove all references.

Applied.

-- 
Kalle Valo

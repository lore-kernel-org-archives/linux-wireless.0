Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:45128 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3KRRED (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 12:04:03 -0500
Received: by mail-lb0-f181.google.com with SMTP id q8so3846530lbi.26
        for <linux-wireless@vger.kernel.org>; Mon, 18 Nov 2013 09:04:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1384794166-10906-6-git-send-email-egrumbach@gmail.com>
References: <1384794166-10906-1-git-send-email-egrumbach@gmail.com>
	<1384794166-10906-6-git-send-email-egrumbach@gmail.com>
Date: Mon, 18 Nov 2013 19:04:01 +0200
Message-ID: <CANUX_P3Y2Tg4gGj7WkyEgeTTmYffFCLtcka9f6aOk=-5r6WVEQ@mail.gmail.com> (sfid-20131118_180407_592960_F8A66768)
Subject: Re: [PATCH 6/6] cfg80211: Fix setting channel in mgmt_tx parameters
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 18, 2013 at 7:02 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
>
> The cfg80211_mgmt_tx_params.chan member wasn't set which
> caused a bug in offchan operations.
>
> Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> Reviewed-by: Johannes Berg <johannes.berg@intel.com>

this one should be folded into the previous one - will resend

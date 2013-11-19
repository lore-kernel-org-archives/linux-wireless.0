Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41430 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3KSO0J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 09:26:09 -0500
Message-ID: <1384871166.15364.5.camel@jlt4.sipsolutions.net> (sfid-20131119_152613_916278_83A20480)
Subject: Re: [PATCH RESEND 5/5] cfg80211: Aggregate mgmt_tx parameters and
 fix channel setting
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Tue, 19 Nov 2013 15:26:06 +0100
In-Reply-To: <1384794409-11211-5-git-send-email-egrumbach@gmail.com> (sfid-20131118_180700_396153_53AB1F8B)
References: <1384794166-10906-1-git-send-email-egrumbach@gmail.com>
	 <1384794409-11211-1-git-send-email-egrumbach@gmail.com>
	 <1384794409-11211-5-git-send-email-egrumbach@gmail.com>
	 (sfid-20131118_180700_396153_53AB1F8B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-11-18 at 19:06 +0200, Emmanuel Grumbach wrote:

> The cfg80211_mgmt_tx_params.chan member wasn't set which
> caused a bug in offchan operations, fix that too.

That's wrong - that was only true when you took the original patch, not
now with the fix rolled in :-)

I guess I'll edit this out (and from subject too)

johannes


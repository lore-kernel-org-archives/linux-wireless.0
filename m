Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56361 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758283Ab3BNRwq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 12:52:46 -0500
Message-ID: <1360864361.8210.13.camel@jlt4.sipsolutions.net> (sfid-20130214_185249_272185_98C70CEE)
Subject: Re: [PATCH v2 1/3] regulatory: allow VHT channels in world roaming
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@do-not-panic.com, green@qca.qualcomm.com
Date: Thu, 14 Feb 2013 18:52:41 +0100
In-Reply-To: <1360799274-16088-2-git-send-email-johannes@sipsolutions.net> (sfid-20130214_004810_651220_97A30DEF)
References: <1360799274-16088-1-git-send-email-johannes@sipsolutions.net>
	 <1360799274-16088-2-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130214_004810_651220_97A30DEF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-14 at 00:47 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> For VHT, the wider bandwidths (up to 160 MHz) need
> to be allowed. Since world roaming only covers the
> case of connecting to an AP, it can be opened up
> there, we will rely on the AP to know the local
> regulations.

Since I don't particularly care about the regulatory stuff right now (we
have custom world roaming) I'm just going to drop this until somebody
else figures out VHT ...

johannes


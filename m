Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36420 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab2FZIvI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 04:51:08 -0400
Message-ID: <1340700658.4662.13.camel@jlt3.sipsolutions.net> (sfid-20120626_105113_553819_C9C18113)
Subject: RE: [PATCH] mac80211: add command to get current rssi
From: Johannes Berg <johannes@sipsolutions.net>
To: DINO MYCLE <dino.mycle@sasken.com>
Cc: sylvain_gmail <sylvain.roger.rieunier@gmail.com>,
	Kalle Valo <kvalo@adurom.com>,
	Victor Goldenshtein <victorg@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 26 Jun 2012 10:50:58 +0200
In-Reply-To: <28DA1CA8CF17234FB030B1ECF787E6B7B93374A1C9@EXGMBX01.sasken.com>
References: <1337669130-4229-1-git-send-email-victorg@ti.com>
	 <4FE85430.3030007@gmail.com> <87y5nb34bm.fsf@purkki.adurom.net>
	 <4FE96D48.9080901@gmail.com>
	 <28DA1CA8CF17234FB030B1ECF787E6B7B93374A1C9@EXGMBX01.sasken.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-26 at 13:50 +0530, DINO MYCLE wrote:
> Hello,
>  Adding the RSSI for each antenna will be useful. We can verify if the
> antenna connectors are proper or not by checking the RSSI value of
> each antenna, Also this will be helpful for outdoor installation where
> they use dual polarized antennas for PtP and PMP systems

Does this make sense for the normal reporting though? I see more value
in reporting it in radiotap monitoring for instance.

johannes


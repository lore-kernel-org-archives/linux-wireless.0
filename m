Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39515 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab2KTHaC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 02:30:02 -0500
Message-ID: <1353396634.9399.1.camel@jlt4.sipsolutions.net> (sfid-20121120_083315_224439_3D37E635)
Subject: Re: [PATCH] mac80211: fix channel context suspend handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 20 Nov 2012 08:30:34 +0100
In-Reply-To: <20650.56024.392104.393540@gargle.gargle.HOWL>
References: <1353360586-32157-1-git-send-email-johannes@sipsolutions.net>
	 <20650.56024.392104.393540@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-20 at 06:50 +0530, Sujith Manoharan wrote:

> Thanks. So there were three warnings which are fixed by:
> 
> mac80211: fix channel context warning on suspend
> mac80211: fix channel context suspend handling
> mac80211: check add_chanctx callback before use in ieee80211_reconfig

Actually, the second patch replaces the first and fixes the suspend
warning as well as the resume ones, so we just need the second and third
patch.

johannes


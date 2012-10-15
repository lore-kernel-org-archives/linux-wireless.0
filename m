Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38311 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab2JOKnv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 06:43:51 -0400
Message-ID: <1350297858.10752.2.camel@jlt4.sipsolutions.net> (sfid-20121015_124353_719712_CDF625D9)
Subject: Re: [PATCH] mac80211: Notify new IBSS network creation
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <c_manoha@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 15 Oct 2012 12:44:18 +0200
In-Reply-To: <20600.1945.579392.240669@gargle.gargle.HOWL> (sfid-20121012_140637_510540_A879F0F6)
References: <20600.1945.579392.240669@gargle.gargle.HOWL>
	 (sfid-20121012_140637_510540_A879F0F6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-10-12 at 17:35 +0530, Sujith Manoharan wrote:
> Initialization of beacon transmission in IBSS mode depends
> on whether a new BSS is being created or joined. When joining
> an existing IBSS network, beaconing has to start only after
> a TSF-sync has happened - this is explained in 11.1.4.
> 
> Introduce a new parameter in the BSS information structure to
> indicate creator/joiner mode.

Applied.

johannes


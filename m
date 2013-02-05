Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46958 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab3BELqE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 06:46:04 -0500
Message-ID: <1360064785.8376.5.camel@jlt4.sipsolutions.net> (sfid-20130205_124608_714050_9229133E)
Subject: Re: [PATCH] mac80211: fix radar check for P2P_DEVICE
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Date: Tue, 05 Feb 2013 12:46:25 +0100
In-Reply-To: <1360061070-15314-1-git-send-email-johannes@sipsolutions.net> (sfid-20130205_114412_543740_77C7C673)
References: <1360061070-15314-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130205_114412_543740_77C7C673)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-05 at 11:44 +0100, Johannes Berg wrote:
> From: Ilan Peer <ilan.peer@intel.com>
> 
> Radar is not required for P2P_DEVICE interfaces.

Applied.

johannes


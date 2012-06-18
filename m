Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53140 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab2FRL4w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 07:56:52 -0400
Message-ID: <1340020610.4615.4.camel@jlt3.sipsolutions.net> (sfid-20120618_135656_490917_2DD81E4E)
Subject: Re: [PATCH v3] mac80211: stop Rx during HW reconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 18 Jun 2012 13:56:50 +0200
In-Reply-To: <1338971102-4872-1-git-send-email-arik@wizery.com> (sfid-20120606_102511_206402_02F7B29B)
References: <1338971102-4872-1-git-send-email-arik@wizery.com>
	 (sfid-20120606_102511_206402_02F7B29B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-06 at 11:25 +0300, Arik Nemtsov wrote:
> While HW reconfig is in progress, drop all incoming Rx. This prevents
> incoming packets from changing the internal state of the driver or
> calling callbacks of the low level driver while it is in inconsistent
> state.

Applied.

johannes


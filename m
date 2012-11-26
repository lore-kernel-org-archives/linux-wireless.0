Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35207 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab2KZKhl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 05:37:41 -0500
Message-ID: <1353926286.9488.12.camel@jlt4.sipsolutions.net> (sfid-20121126_113744_739714_64B5BB36)
Subject: Re: [PATCH 0/3] mesh-related cleanups
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, thomas@cozybit.com,
	linux-wireless@vger.kernel.org
Date: Mon, 26 Nov 2012 11:38:06 +0100
In-Reply-To: <1353552032-15600-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353552032-15600-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-21 at 18:40 -0800, Marco Porsch wrote:
> Some cleanups requested by Johannes after the mesh powersave RFC.

Applied all, thanks!

I renamed the MESHCONF_PARAM_* to IEEE80211_MESHCONF_PARAM_*, please
adjust your other patches (but let's give the people in the US some time
to recover from turkey overeating first and then time to review) :-)

johannes


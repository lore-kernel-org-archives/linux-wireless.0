Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35103 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab2FFImM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 04:42:12 -0400
Message-ID: <1338972130.4513.18.camel@jlt3.sipsolutions.net> (sfid-20120606_104217_252642_4E820E46)
Subject: Re: [RFC 6/6] mac80211: reuse channels for channel context
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 10:42:10 +0200
In-Reply-To: <1337342589-10617-7-git-send-email-michal.kazior@tieto.com>
References: <1337342589-10617-1-git-send-email-michal.kazior@tieto.com>
	 <1337342589-10617-7-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-05-18 at 14:03 +0200, Michal Kazior wrote:
> Reuse channels with compatible channel types. Some
> channel types are compatible and can be used
> concurrently.

Yeah, ok, I wasn't paying attention to the last patch when looking at
the first! :-)

johannes


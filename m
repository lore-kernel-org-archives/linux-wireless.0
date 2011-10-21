Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48713 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab1JUKFG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 06:05:06 -0400
Subject: Re: [RFC 4/7] mac80211: setting link-specific mesh power modes
 when plink open
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAG5dHkT8fPodB_ejoqSmH4Dgr-ynuMzwo5r5czXfCWgJWLiS=w@mail.gmail.com> (sfid-20111021_103730_949262_32D1DC8A)
References: <CAG5dHkT8fPodB_ejoqSmH4Dgr-ynuMzwo5r5czXfCWgJWLiS=w@mail.gmail.com>
	 (sfid-20111021_103730_949262_32D1DC8A)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Oct 2011 12:05:02 +0200
Message-ID: <1319191502.3964.11.camel@jlt3.sipsolutions.net> (sfid-20111021_120510_380916_E9FFC832)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-21 at 12:37 +0400, Ivan Bezyazychnyy wrote:
> Setting peer link-specific power mode equal to peer non-peer power mode
> value and local link-specific power mode equal to local non-peer value

You really need more verbose changelogs, I can't even parse that
properly. How about mentioning why, what it means, etc?

You should also extend your cover letter to explain how the power save
stuff works.

johannes


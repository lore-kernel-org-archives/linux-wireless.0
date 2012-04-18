Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33726 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab2DRBq7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 21:46:59 -0400
Message-ID: <1334713585.3725.22.camel@jlt3.sipsolutions.net> (sfid-20120418_034702_399086_9F4BE844)
Subject: Re: [PATCH v5] mac80211: Support on-channel scan option.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Apr 2012 18:46:25 -0700
In-Reply-To: <1334685256-14123-1-git-send-email-greearb@candelatech.com> (sfid-20120417_195429_265193_DA2F0B63)
References: <1334685256-14123-1-git-send-email-greearb@candelatech.com>
	 (sfid-20120417_195429_265193_DA2F0B63)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-04-17 at 10:54 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This based on an idea posted by Stanislaw Gruszka,
> though I accept full blame for the implementation!
> 
> This has been tested with ath9k.
> 
> The idea is to let users scan on the current operating
> channel without interrupting normal traffic more than
> absolutely necessary (changing power level might reset
> some hardware, for instance).

Seems OK to me now. I might change the subject/description a bit to note
that really it's not an "option" but an optimisation if the user
requests a single-channel on-channel scan, but ultimately I don't really
care all that much.

johannes


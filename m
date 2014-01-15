Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38267 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaAONXw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 08:23:52 -0500
Message-ID: <1389792228.4338.7.camel@jlt4.sipsolutions.net> (sfid-20140115_142355_890298_0DCF01C7)
Subject: Re: [RFC 1/5] cfg80211: regulatory rules, fix bw checking
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com
Date: Wed, 15 Jan 2014 14:23:48 +0100
In-Reply-To: <1389720570-2430-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140114_182945_998805_0069F355)
References: <1389720570-2430-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1389720570-2430-2-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140114_182945_998805_0069F355)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-14 at 18:29 +0100, Janusz Dziedzic wrote:
> Allow BW cross over REG_RULES if rules continous.
> 
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> ---
> I am not sure about rule_intersect() here ...

I'm not sure about the whole thing ...

We did discuss something like this previously (and see our todo list on
the wiki), but this isn't just some arbitrary internal change, it
completely changes the interpretation of the regulatory database.

At a minimum, that means you need a big commit log discussing the impact
of the changes etc.

johannes


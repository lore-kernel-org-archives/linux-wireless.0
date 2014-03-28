Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48331 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaC1JwE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 05:52:04 -0400
Message-ID: <1396000321.4175.16.camel@jlt4.sipsolutions.net> (sfid-20140328_105208_971473_111583D4)
Subject: Re: [PATCH v2 0/4] mac80211/cfg80211: CSA fixes/cleanups
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Mar 2014 10:52:01 +0100
In-Reply-To: <1395408675-26013-1-git-send-email-michal.kazior@tieto.com> (sfid-20140321_143714_646969_A45049EC)
References: <1394029623-21894-1-git-send-email-michal.kazior@tieto.com>
	 <1395408675-26013-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140321_143714_646969_A45049EC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-21 at 14:31 +0100, Michal Kazior wrote:
> Hi,
> 
> The patchset fixes CSA tx queue locking and
> introduces interface teardown upon CSA failure
> during finalization.

Looks like you have some comments still, I'll assume you'll repost.

johannes


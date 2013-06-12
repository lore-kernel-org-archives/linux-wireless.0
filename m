Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49750 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816Ab3FLWAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 18:00:10 -0400
Date: Wed, 12 Jun 2013 17:56:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2013-06-12
Message-ID: <20130612215644.GA906@tuxdriver.com> (sfid-20130613_000014_325982_94B850EE)
References: <1371019363.8601.6.camel@jlt4.sipsolutions.net>
 <1371021295.8601.8.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1371021295.8601.8.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 12, 2013 at 09:14:55AM +0200, Johannes Berg wrote:
> Let's try that again :-)
> 
> Following davem's complaint about my patch, here's a new pull request
> w/o the patch he was complaining about, but instead with the const fix
> rolled into the fix.
> 
> I have a fix for radar detection, one for rate control and a workaround
> for broken HT APs which is a regression fix because we didn't rely on
> them to be correct before.
> 
> johannes
> 
> 
> The following changes since commit ac20976dcaeea3e77e40e9aac8f3799d2a22ea2b:
> 
>   mac80211: Allow single vif mac address change with addr_mask (2013-05-27 11:26:48 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to 795d855d56c6d172f50a974f603ba923ac93ee76:
> 
>   mac80211: Fix rate control mask matching call (2013-06-12 09:12:43 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

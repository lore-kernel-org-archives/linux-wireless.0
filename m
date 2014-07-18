Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49544 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009AbaGRRAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 13:00:10 -0400
Date: Fri, 18 Jul 2014 12:56:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211 2014-07-18
Message-ID: <20140718165632.GD31114@tuxdriver.com> (sfid-20140718_190014_881634_6A84972B)
References: <1405670268.19195.3.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1405670268.19195.3.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 18, 2014 at 09:57:48AM +0200, Johannes Berg wrote:
> John,
> 
> This is late - maybe it won't come in time. I was busy moving to our new
> house.
> 
> I have two fixes: one for tracing that fixes a long-standing NULL
> pointer dereference, and one for a mac80211 issue that causes iwlmvm to
> send invalid frames during authentication/association.
> 
> Let me know if there any problems.
> 
> johannes
> 
> 
> The following changes since commit 02df00eb0019e7d15a1fcddebe4d020226c1ccda:
> 
>   nl80211: move set_qos_map command into split state (2014-06-24 16:13:10 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git HEAD
> 
> for you to fetch changes up to 8c26d458394be44e135d1c6bd4557e1c4e1a0535:
> 
>   cfg80211: fix mic_failure tracing (2014-07-18 09:53:56 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

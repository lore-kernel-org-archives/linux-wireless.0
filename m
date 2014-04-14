Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41760 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947AbaDNSaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 14:30:17 -0400
Date: Mon, 14 Apr 2014 14:19:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211 2014-04-11
Message-ID: <20140414181926.GE27324@tuxdriver.com> (sfid-20140414_203035_490688_255FEA63)
References: <1397203735.4420.10.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1397203735.4420.10.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 11, 2014 at 10:08:55AM +0200, Johannes Berg wrote:
> Hi John,
> 
> First few fixes ... nothing big though.
> 
> We have a fix from Chun-Yeow to not look at management frame bitrates
> that are typically really low, two fixes from Felix for AP_VLAN
> interfaces, a fix from Ido to disable SMPS settings when a monitor
> interface is enabled, a radar detection fix from Michał and a fix from
> myself for a very old remain-on-channel bug.
> 
> Let me know if there's any problem.
> 
> johannes
> 
> 
> The following changes since commit ce7613db2d8d4d5af2587ab5d7090055c4562201:
> 
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2014-04-08 12:41:23 -0700)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to 764152ff66f4a8be1f9d7981e542ffdaa5bd7aff:
> 
>   mac80211: exclude AP_VLAN interfaces from tx power calculation (2014-04-11 09:37:41 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60639 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527Ab3HISAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 14:00:13 -0400
Date: Fri, 9 Aug 2013 13:49:39 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-fixes 2013-08-06
Message-ID: <20130809174939.GJ30925@tuxdriver.com> (sfid-20130809_200017_653757_908DB963)
References: <1375779012.8219.3.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375779012.8219.3.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 06, 2013 at 10:50:12AM +0200, Johannes Berg wrote:
> John,
> 
> I have a few more fixes for iwlwifi.
> 
> We revert an rfkill bugfix that unfortunately caused more bugs, shuffle
> some code to avoid touching the PCIe device before it's enabled and
> disconnect if firmware fails to do our bidding. I also have Stanislaw's
> fix to not crash in some channel switch scenarios.
> 
> Let me know if there's any problem.
> 
> Thanks,
> johannes
> 
> The following changes since commit a53ee0a308b16e392e0219c585b10f329345766b:
> 
>   iwlwifi: pcie: clear RFKILL interrupt in AMPG (2013-07-26 10:07:10 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git for-john
> 
> for you to fetch changes up to 057397943eee0bf3bc01a58ee52a9a6f1810258e:
> 
>   iwlwifi: mvm: disconnect if time event scheduling fails (2013-08-06 10:35:19 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

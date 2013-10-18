Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41841 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783Ab3JRRpc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 13:45:32 -0400
Date: Fri, 18 Oct 2013 13:35:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-fixes 2013-10-18
Message-ID: <20131018173513.GA28130@tuxdriver.com> (sfid-20131018_194535_676555_B2042BBC)
References: <1382105527.14393.3.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1382105527.14393.3.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 18, 2013 at 04:12:07PM +0200, Johannes Berg wrote:
> John,
> 
> Before you travel to Edinburgh, I hope to get in another pull request.
> Or maybe when you are there? :-)
> 
> I have a few fixes for warnings/issues: one from Alex, fixing scan
> timings, one from Emmanuel fixing a WARN_ON in the DVM driver, one from
> Stanislaw removing a trigger-happy WARN_ON in the MVM driver and a
> change from myself to try to recover when the device isn't processing
> commands quickly.
> 
> Please let me know if there's any issue.
> 
> johannes
> 
> 
> The following changes since commit 5a3e9f7f8c8768b5f7df81100c684e4cd00a6eb5:
> 
>   iwlwifi: mvm: call ieee80211_scan_completed when needed (2013-10-02 11:25:50 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git for-john
> 
> for you to fetch changes up to f6b129527ca15bae29ffb9417ddaa1c9d99ffc5d:
> 
>   iwlwifi: dvm: don't override mac80211's queue setting (2013-10-18 16:03:14 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

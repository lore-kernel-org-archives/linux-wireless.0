Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:32872 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102AbaBDUaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 15:30:21 -0500
Date: Tue, 4 Feb 2014 15:15:09 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2014-02-03
Message-ID: <20140204201508.GC13887@tuxdriver.com> (sfid-20140204_213025_010394_B038584F)
References: <52EFFCE8.6070505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52EFFCE8.6070505@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 03, 2014 at 10:32:40PM +0200, Emmanuel Grumbach wrote:
> Hi John,
> 
> since you updated your trees, here is a set of fixes for 3.14.
> 
> I have an important fix that disables A band in case the driver thought
> it was enabled, and the firmware disagreed. We ended up making the
> firmware unhappy. I also fix the station table in AP mode and fix the
> scan while we have BT working.
> Johannes removes a static variable that could potentially lead to to
> issues on multi-device setups and disables scheduled scan to avoid
> issues with old versions of wpa_supplicant.
> A small fix from David on scan and a few new device IDs for 7265.
> 
> Let me know about issues you may have!
> 
> The following changes since commit 9b0cd304f26b9fca140de15deeac2bf357d1f388:
> 
>   Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux
> (2014-01-29 20:49:12 -0800)
> 
> are available in the git repository at:
> 
> 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git
> for-john
> 
> for you to fetch changes up to c512865446e6dd5b6e91e81187e75b734ad7cfc7:
> 
>   iwlwifi: mvm: don't allow A band if SKU forbids it (2014-02-02
> 11:08:42 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

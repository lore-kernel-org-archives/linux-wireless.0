Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40146 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241AbaIZRpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 13:45:11 -0400
Date: Fri, 26 Sep 2014 13:38:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux NFC <linux-nfc@ml01.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: [GIT] [3.18] NFC update
Message-ID: <20140926173818.GG22967@tuxdriver.com> (sfid-20140926_194533_888280_2EC8E5B5)
References: <20140924003423.GF4235@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140924003423.GF4235@zurbaran>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 24, 2014 at 02:34:23AM +0200, Samuel Ortiz wrote:
> Hi John,
> 
> This is the NFC pull request for 3.18.
> 
> We've had major updates for TI and ST Microelectronics drivers, and a
> few NCI related changes.
> 
> For TI's trf7970a driver:
> 
> - Target mode support for trf7970a
> - Suspend/resume support for trf7970a
> - DT properties additions to handle different quirks
> - A bunch of fixes for smartphone IOP related issues
> 
> For ST Microelectronics' ST21NFCA and ST21NFCB drivers:
> 
> - ISO15693 support for st21nfcb
> - checkpatch and sparse related warning fixes
> - Code cleanups and a few minor fixes
> 
> Finally, Marvell added ISO15693 support to the NCI stack, together with a
> couple of NCI fixes.
> 
> Thanks in advance for pulling those in.
> 
> The following changes since commit 6a5d088a923854569e20eac4f3f569926d5911ec:
> 
>   carl9170: tx: Replace rcu_assign_pointer() with RCU_INIT_POINTER() (2014-08-28 14:50:13 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.18-1
> 
> for you to fetch changes up to 094e93592433312548dd5e43d7b24b152f658063:
> 
>   NFC: st21nfca: Fix potential double kfree_skb error (2014-09-24 02:02:24 +0200)

Pulling now, but I don't plan to push it back out until Dave pulls my earlier batch...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

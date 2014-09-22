Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53189 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbaIVUAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2014 16:00:19 -0400
Date: Mon, 22 Sep 2014 15:59:50 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux NFC <linux-nfc@ml01.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: [GIT] [3.17] NFC fixes
Message-ID: <20140922195950.GE23806@tuxdriver.com> (sfid-20140922_220054_767512_E347C30A)
References: <20140922195553.GC4235@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140922195553.GC4235@zurbaran>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 22, 2014 at 09:55:54PM +0200, Samuel Ortiz wrote:
> Hi John,
> 
> Hopefully not too late for a handful of NFC fixes:
> 
> - 2 potential build failures for ST21NFCA and ST21NFCB, triggered by a
>   depmod dependenyc cycle.
> - One potential buffer overflow in the microread driver.
> 
> The following changes since commit 1bd3fa7b8c9b2936c16c6e6452f9cc991c405872:
> 
>   Merge branch 'for-john' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes (2014-09-04 13:12:02 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-fixes.git tags/nfc-fixes-3.17-1
> 
> for you to fetch changes up to 300c627fbc52aa5b2117ca267907ab8d7b990ead:
> 
>   NFC: st21nfca: Fix potential depmod dependency cycle (2014-09-07 23:45:53 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

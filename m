Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52290 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095AbaAFTaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 14:30:21 -0500
Date: Mon, 6 Jan 2014 14:22:42 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux NFC <linux-nfc@ml01.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: [GIT] [3.12] NFC fix
Message-ID: <20140106192242.GE10885@tuxdriver.com> (sfid-20140106_203028_154450_86946A6D)
References: <20140104234802.GA10578@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140104234802.GA10578@zurbaran>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

3.13 is the current stream.  Do you want to adjust your tag name?

John

On Sun, Jan 05, 2014 at 12:48:02AM +0100, Samuel Ortiz wrote:
> Hi John,
> 
> Hopefully it's not too late for a 3.12 fix for NFC. Please let me know
> if it is, and I'll add it to my 3.13 pull request.
> 
> This pull request only contains one fix for a regression introduced with
> commit e29a9e2ae165620d. Without this fix, we can not establish a p2p link
> in target mode. Only initiator mode works.
> 
> The following changes since commit b7e047358449f8eb5cba8197b42280b676b82e54:
> 
>   Merge branch 'for-upstream' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth (2013-12-18 13:46:08 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-fixes.git tags/nfc-fixes-3.12-1
> 
> for you to fetch changes up to d31652a26bc9e752a99b6ac3b61353129934e451:
> 
>   NFC: Fix target mode p2p link establishment (2014-01-04 03:31:32 +0100)
> 
> ----------------------------------------------------------------
> Arron Wang (1):
>       NFC: Fix target mode p2p link establishment
> 
>  net/nfc/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> -- 
> Intel Open Source Technology Centre
> http://oss.intel.com/
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

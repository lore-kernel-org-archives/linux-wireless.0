Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58001 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbaBXTpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Feb 2014 14:45:16 -0500
Date: Mon, 24 Feb 2014 14:44:55 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux NFC <linux-nfc@ml01.01.org>
Subject: Re: [GIT] [3.14] NFC fix
Message-ID: <20140224194455.GD24810@tuxdriver.com> (sfid-20140224_204521_502682_8E1CBC25)
References: <20140223225054.GN18868@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140223225054.GN18868@zurbaran>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 23, 2014 at 11:50:54PM +0100, Samuel Ortiz wrote:
> Hi John,
> 
> We only have one candidate for 3.14 fixes, and this is a NCI NULL
> pointer dereference introduced during the 3.14 merge window.
> 
> The following changes since commit b3050248c167871ca52cfdb2ce78aa2460249346:
> 
>   ath9k: Fix ETSI compliance for AR9462 2.0 (2014-02-20 15:53:20 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-fixes.git tags/nfc-fixes-3.14-1
> 
> for you to fetch changes up to 44a589ca2de4d7980f8b335481a09bf818065dbe:
> 
>   NFC: NCI: Fix NULL pointer dereference (2014-02-23 23:14:45 +0100)
 
Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

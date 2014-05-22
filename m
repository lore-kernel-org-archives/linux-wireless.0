Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45050 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaEVSAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 14:00:13 -0400
Date: Thu, 22 May 2014 13:57:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux NFC <linux-nfc@ml01.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: [GIT] [3.16] NFC update
Message-ID: <20140522175755.GB12779@tuxdriver.com> (sfid-20140522_200017_673799_2B7630C5)
References: <20140520221319.GA15540@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140520221319.GA15540@zurbaran>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 21, 2014 at 12:13:19AM +0200, Samuel Ortiz wrote:
> Hi John,
> 
> This is the NFC pull request for 3.16. We have:
> 
> - STMicroeectronics st21nfca support. The st21nfca is an HCI chipset and
>   thus relies on the HCI stack. This submission provides support for tag
>   redaer/writer mode (including Type 5) and device tree bindings.
> 
> - PM runtime support and a bunch of bug fixes for TI's trf7970a.
> 
> - Device tree support for NXP's pn544. Legacy platform data support is
>   obviously kept intact.
> 
> - NFC Tag type 4B support to the NFC Digital stack.
> 
> - SOCK_RAW type support to the raw NFC socket, and allow NCI
>   sniffing from that. This can be extended to report HCI frames and also
>   proprietarry ones like e.g. the pn533 ones.
> 
> Thanks in advance for pulling those in.
> 
> The following changes since commit 321d03c86732e45f5f33ad0db5b68e2e1364acb9:
> 
>   Merge branch 'misc' of git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild (2014-04-12 18:22:27 -0700)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git nfc-next-3.16-1
> 
> for you to fetch changes up to 7974728094d35f38775417a26d8f30ea3602496a:
> 
>   NFC: st21nfca: Add ISO15693 Reader/Writer support (2014-05-20 00:48:28 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

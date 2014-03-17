Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43220 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278AbaCQRaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 13:30:14 -0400
Date: Mon, 17 Mar 2014 13:18:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux NFC <linux-nfc@ml01.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: [GIT] [3.15] NFC update
Message-ID: <20140317171814.GB20367@tuxdriver.com> (sfid-20140317_183020_198127_5118B168)
References: <20140314200536.GM27197@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140314200536.GM27197@zurbaran>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 14, 2014 at 09:05:36PM +0100, Samuel Ortiz wrote:
> Hi John,
> 
> This is the NFC pull request for 3.15. With this one we have:
> 
> - Support for ISO 15693 a.k.a. NFC vicinity a.k.a. Type 5 tags. ISO
>   15693 are long range (1 - 2 meters) vicinity tags/cards. The kernel
>   now supports those through the NFC netlink and digital APIs.
> 
> - Support for TI's trf7970a chipset. This chipset relies on the NFC
>   digital layer and the driver currently supports type 2, 4A and 5 tags.
> 
> - Support for NXP's pn544 secure firmare download. The pn544 C3 chipsets
>   relies on a different firmware download protocal than the C2 one. We
>   now support both and use the right one depending on the version we
>   detect at runtime.
> 
> - Support for 4A tags from the NFC digital layer.
> 
> - A bunch of cleanups and minor fixes from Axel Lin and Thierry Escande.
> 
> Thanks in advance for pulling those in.
> 
> The following changes since commit 35582ad9d342025653aaf28ed321bf5352488d7f:
> 
>   Staging: rtl8812ae: remove modules field of rate_control_ops (2014-02-13 15:23:23 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.15-1
> 
> for you to fetch changes up to 29e27dd86b5c4f8e6feb62d7b6a8491539ff1ef1:
> 
>   NFC: llcp: Use list_for_each_entry in nfc_llcp_find_local() (2014-03-14 20:19:08 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

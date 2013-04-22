Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sapphire.tuxdriver.com ([70.61.120.61]:47782 "EHLO
	linville-x1.hq.tuxdriver.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754579Ab3DVS4A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 14:56:00 -0400
Date: Mon, 22 Apr 2013 14:55:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux NFC <linux-nfc@ml01.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: [GIT] [3.10] NFC pull request
Message-ID: <20130422185537.GD2055@tuxdriver.com> (sfid-20130422_205617_562959_EA9DEFDD)
References: <20130415230508.GL8798@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130415230508.GL8798@zurbaran>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 16, 2013 at 01:05:08AM +0200, Samuel Ortiz wrote:
> Hi John,
> 
> A bit late, but this is the 2nd NFC pull request for 3.10.
> 
> With this one we have:
> 
> - A major pn533 update. The pn533 framing support has been changed in order to
>   easily support all pn533 derivatives. For example we now support the ACR122
>   USB dongle.
> 
> - An NFC MEI physical layer code factorization through the mei_phy NFC API.
>   Both the microread and the pn544 drivers now use it.
> 
> - LLCP aggregation support. This allows NFC p2p devices to send aggregated
>   frames containing all sort of LLCP frames except SYMM and aggregation
>   frames.
> 
> - More LLCP socket options for getting the remote device link parameters.
> 
> - Fixes for the LLCP socket option code added with the first pull request for
>   3.10.
> 
> - Some support for LLCP corner cases like 0 length SDUs and general DISC
>   (tagged with a 0,0 dsap ssap couple) handling.
> 
> - RFKILL support for NFC.
> 
> Thanks in advance for pulling them in.
> 
> The following changes since commit fe29f54cd574eab7b521445419f355c0ecd995cc:
> 
>   ipw2x00: move to kstrto* functions (2013-04-10 14:10:34 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.10-2
> 
> for you to fetch changes up to bb03dceb83852614ae3ad6b3731a31422890b0b9:
> 
>   NFC: pn544: Add MEI physical layer (2013-04-16 00:39:41 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

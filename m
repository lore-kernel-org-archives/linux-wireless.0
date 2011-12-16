Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49449 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756517Ab1LPOAX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 09:00:23 -0500
Date: Fri, 16 Dec 2011 15:04:54 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	linux-wireless@vger.kernel.org
Subject: Re: NFC build failure on current wireless-testing
Message-ID: <20111216140454.GD11800@sortiz-mobl> (sfid-20111216_150026_929501_FA448CA7)
References: <20111216133323.GC14271@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111216133323.GC14271@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Fri, Dec 16, 2011 at 02:33:24PM +0100, Stanislaw Gruszka wrote:
> Got this today after pulling wireless-testing tree:
> 
> LD [M]  net/nfc/nfc.o
> net/nfc/netlink.o: In function `nfc_llcp_mac_is_down':
> netlink.c:(.text+0x0): multiple definition of `nfc_llcp_mac_is_down'
> net/nfc/core.o:(.text+0x0): first defined here
> net/nfc/netlink.o: In function `nfc_llcp_mac_is_up':
> netlink.c:(.text+0x10): multiple definition of `nfc_llcp_mac_is_up'
> net/nfc/core.o:(.text+0x10): first defined here
> net/nfc/af_nfc.o: In function `nfc_llcp_mac_is_down':
> (.text+0x0): multiple definition of `nfc_llcp_mac_is_down'
> net/nfc/core.o:(.text+0x0): first defined here
> net/nfc/af_nfc.o: In function `nfc_llcp_mac_is_up':
> (.text+0x10): multiple definition of `nfc_llcp_mac_is_up'
> net/nfc/core.o:(.text+0x10): first defined here
> net/nfc/rawsock.o: In function `nfc_llcp_mac_is_down':
> rawsock.c:(.text+0x0): multiple definition of `nfc_llcp_mac_is_down'
> net/nfc/core.o:(.text+0x0): first defined here
> net/nfc/rawsock.o: In function `nfc_llcp_mac_is_up':
> rawsock.c:(.text+0x10): multiple definition of `nfc_llcp_mac_is_up'
> net/nfc/core.o:(.text+0x10): first defined here
> make[2]: *** [net/nfc/nfc.o] Error 1
> make[1]: *** [net/nfc] Error 2
> make: *** [net] Error 2
> 
> Config attached.
Sorry about that, I just sent a fix to John.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

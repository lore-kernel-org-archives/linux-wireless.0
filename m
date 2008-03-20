Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:58466 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbYCTTlG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2008 15:41:06 -0400
Date: Thu, 20 Mar 2008 20:41:01 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Daniel Drake <dsd@gentoo.org>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH/RFC v3] introduce ARCH_CAN_UNALIGNED_ACCESS Kconfig symbol
Message-ID: <20080320194101.GC17884@uranus.ravnborg.org> (sfid-20080320_194116_298435_F84850A5)
References: <1206023695.16475.137.camel@johannes.berg> <20080320181310.GA17884@uranus.ravnborg.org> <1206038373.16475.150.camel@johannes.berg> <1206038734.16475.153.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1206038734.16475.153.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 20, 2008 at 07:45:34PM +0100, Johannes Berg wrote:
> Subject: introduce HAVE_UNALIGNED_ACCESS_SUPPORT Kconfig symbol
> 
> In many cases, especially in networking, it can be beneficial to
> know at compile time whether the architecture can do unaligned
> accesses. This patch introduces a new Kconfig symbol
> 	HAVE_UNALIGNED_ACCESS_SUPPORT
> for that purpose and adds it to the powerpc and x86 architectures.
> Also add some documentation about alignment and networking, and
> especially one intended use of this symbol.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam


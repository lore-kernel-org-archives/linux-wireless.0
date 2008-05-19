Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:57185 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756357AbYESRU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 13:20:59 -0400
Date: Mon, 19 May 2008 19:20:51 +0200
From: Sebastian Siewior <liber+tas@ml.breakpoint.cc>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linville@tuxdriver.com, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: Fix ethtool statistics
Message-ID: <20080519172051.GA16813@Chamillionaire.breakpoint.cc> (sfid-20080519_192146_958751_744AE3B5)
References: <1211211122.21380.167.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <1211211122.21380.167.camel@pmac.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* David Woodhouse | 2008-05-19 16:32:02 [+0100]:

>Fix various problems:
> - We converted MESH_ACCESS to a direct command but missed this caller.
> - We were trying to access mesh stats even on meshless firmware.
> - We should really zero the buffer if something goes wrong.
>
>Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Cheers

Sebastian

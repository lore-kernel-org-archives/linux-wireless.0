Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:36780 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933093AbcBBP77 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 10:59:59 -0500
Date: Tue, 2 Feb 2016 21:29:44 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Paul Mcquade <paulmcquad@gmail.com>
Cc: sgruszka@redhat.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: net: wireless: rt2x00: Fixed Spacing issues
Message-ID: <20160202155944.GA8235@sudip-laptop> (sfid-20160202_170030_791190_46BE1BC8)
References: <1445112279-27796-1-git-send-email-paulmcquad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445112279-27796-1-git-send-email-paulmcquad@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 17, 2015 at 09:04:39PM +0100, Paul Mcquade wrote:
> Removed empty spaces before/after parenthesis
> 
> Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
> Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
> 
> ---
> drivers/net/wireless/rt2x00/rt61pci.h | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)

This patch and your other patches related to rt2x00 will not apply
anymore as the driver has moved to drivers/net/wireless/ralink/rt2x00

can you please send them again after rebasing against current tree..

regards
sudip

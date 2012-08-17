Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:42550 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757927Ab2HQWDB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2012 18:03:01 -0400
Date: Sat, 18 Aug 2012 00:02:37 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Syam Sidhardhan <syamsidhardh@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org
Subject: Re: [PATCH] NFC: Remove repeated code for NULL check
Message-ID: <20120817220237.GC5179@sortiz-mobl> (sfid-20120818_000401_624063_BE531A04)
References: <1345058743-2514-1-git-send-email-s.syam@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1345058743-2514-1-git-send-email-s.syam@samsung.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Syam,

On Thu, Aug 16, 2012 at 12:55:43AM +0530, Syam Sidhardhan wrote:
> This patch remove the repeated code for checking llcp_sock &
> llcp_sock->dev against NULL.
> 
> Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
> ---
>  net/nfc/llcp/sock.c |    3 ---
>  1 file changed, 3 deletions(-)
Applied to my nfc-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

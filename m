Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:40984 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663Ab2GEPed (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 11:34:33 -0400
Date: Thu, 5 Jul 2012 17:45:54 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC: Don't warn when closing uninitialized socket
Message-ID: <20120705154554.GJ18200@sortiz-mobl> (sfid-20120705_173451_048041_CBDC0BB6)
References: <1341228702-9924-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1341228702-9924-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sasha,

On Mon, Jul 02, 2012 at 01:31:42PM +0200, Sasha Levin wrote:
> It is possible to close a NFC socket without initializing it first,
> there's no need to warn about it.
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  net/nfc/llcp/llcp.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
I already fixed this one, with your reported-by.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

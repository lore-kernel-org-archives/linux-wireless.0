Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:6470 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbbDGKHl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2015 06:07:41 -0400
Date: Tue, 7 Apr 2015 12:07:38 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [resend PATCH] nfc: logging neatening
Message-ID: <20150407100738.GA9511@ribalta.mp.intel.com> (sfid-20150407_120758_557057_C10A7C53)
References: <1428391020.20888.31.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1428391020.20888.31.camel@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

On Tue, Apr 07, 2015 at 12:17:00AM -0700, Joe Perches wrote:
> Add missing terminating newlines to nfc_info and nfc_err
> to avoid possible interleaving from other messages.
> 
> Miscellanea:
> 
> o typo fix of "unknonwn" in message
> o remove unnecessary OOM messages as there's a generic dump_stack()
> o realign arguments
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> 
> Adding Andrew Morton
> Resending after a 8 weeks with no reply/review.
> 
>  drivers/nfc/microread/i2c.c |  2 +-
>  drivers/nfc/nfcmrvl/main.c  |  4 ++--
>  drivers/nfc/nfcmrvl/usb.c   | 18 +++++++++---------
>  drivers/nfc/pn533.c         |  2 +-
>  drivers/nfc/pn544/i2c.c     |  7 ++-----
>  drivers/nfc/port100.c       | 36 ++++++++++++++++++------------------
>  drivers/nfc/st21nfcb/i2c.c  |  5 +----
>  drivers/nfc/st21nfcb/ndlc.c |  5 ++---
>  8 files changed, 36 insertions(+), 43 deletions(-)
Sorry for the lag. Patch applied to nfc-next now.

Cheers,
Samuel.

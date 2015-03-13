Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0059.hostedemail.com ([216.40.44.59]:60267 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751038AbbCMHfR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 03:35:17 -0400
Message-ID: <1426232111.11459.5.camel@perches.com> (sfid-20150313_083547_740982_74624BF9)
Subject: Re: [PATCH] nfc: logging neatening
From: Joe Perches <joe@perches.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 13 Mar 2015 00:35:11 -0700
In-Reply-To: <1423771820.15343.36.camel@perches.com>
References: <1423771820.15343.36.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-02-12 at 12:10 -0800, Joe Perches wrote:
> Add missing terminating newlines to nfc_info and nfc_err
> to avoid possible interleaving from other messages.

ping?

> Miscellanea:
> 
> o typo fix of "unknonwn" in message
> o remove unnecessary OOM messages as there's a generic dump_stack()
> o realign arguments
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/nfc/microread/i2c.c |  2 +-
>  drivers/nfc/nfcmrvl/main.c  |  4 ++--
>  drivers/nfc/nfcmrvl/usb.c   | 18 +++++++++---------
>  drivers/nfc/pn533.c         |  2 +-
>  drivers/nfc/pn544/i2c.c     |  7 ++-----
>  drivers/nfc/port100.c       | 36 ++++++++++++++++++------------------
>  drivers/nfc/st21nfcb/i2c.c  |  5 +----
>  drivers/nfc/st21nfcb/ndlc.c |  5 ++---
>  8 files changed, 36 insertions(+), 43 deletions(-)



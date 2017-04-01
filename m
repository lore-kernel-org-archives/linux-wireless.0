Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:54575 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751997AbdDAWhJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Apr 2017 18:37:09 -0400
Date: Sun, 2 Apr 2017 00:37:06 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] nfc: fdp: fix NULL pointer dereference
Message-ID: <20170401223706.GI22034@zurbaran.ger.intel.com> (sfid-20170402_003736_689823_FFD3BAD6)
References: <1482268144-14028-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1482268144-14028-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sudip,

On Tue, Dec 20, 2016 at 09:09:04PM +0000, Sudip Mukherjee wrote:
> We are checking phy after dereferencing it. We can print the debug
> information after checking it. If phy is NULL then we will get a good
> stack trace to tell us that we are in this irq handler.
> 
> Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
> ---
>  drivers/nfc/fdp/i2c.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.

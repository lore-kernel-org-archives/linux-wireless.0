Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:29991 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751933AbdDAVnz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Apr 2017 17:43:55 -0400
Date: Sat, 1 Apr 2017 23:43:48 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Geliang Tang <geliangtang@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC: nfcmrvl: drop duplicate header gpio.h
Message-ID: <20170401214348.GA22034@zurbaran.ger.intel.com> (sfid-20170401_234458_054683_4261CCEE)
References: <15299de49216a2360976ca37ff774cae9d27d88b.1479991297.git.geliangtang@gmail.com>
 <b3d55dda173172b385d7e617cf07ec00efae9b49.1479991468.git.geliangtang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b3d55dda173172b385d7e617cf07ec00efae9b49.1479991468.git.geliangtang@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Geliang,

On Thu, Nov 24, 2016 at 09:58:34PM +0800, Geliang Tang wrote:
> Drop duplicate header gpio.h from nfcmrvl/spi.c.
> 
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> ---
>  drivers/nfc/nfcmrvl/spi.c | 1 -
>  1 file changed, 1 deletion(-)
Patch applied, thanks.

Cheers,
Samuel.

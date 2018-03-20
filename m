Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38226 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751587AbeCTLrX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 07:47:23 -0400
Date: Tue, 20 Mar 2018 12:47:21 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: hariprasath.elango@gmail.com
Cc: aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        dan.carpenter@oracle.com, gehariprasath@gmail.com,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] staging: wilc1000: replace switch statement by simple
 if condition
Message-ID: <20180320114720.GA31253@kroah.com> (sfid-20180320_124739_205668_E126AFAD)
References: <20180320114331.4084-1-hariprasath.elango@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180320114331.4084-1-hariprasath.elango@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 20, 2018 at 05:13:31PM +0530, hariprasath.elango@gmail.com wrote:
> From: HariPrasath Elango <hariprasath.elango@gmail.com>
> 
> In this case,there is only a single switch case statement.So replacing
> by a simple if condition
> 
> Signed-off-by: HariPrasath Elango <hariprasath.elango@gmail.com>
> ---
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)

What changed from v1?  Always put that information below the --- line,
like the kernel documentation asks you to do.

v3?  :)

thanks,

greg k-h

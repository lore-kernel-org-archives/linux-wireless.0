Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:38080 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbeCTMIu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 08:08:50 -0400
From: "<Hariprasath Elango>" <hariprasath.elango@gmail.com>
Date: Tue, 20 Mar 2018 17:38:42 +0530
To: Greg KH <gregkh@linuxfoundation.org>
Cc: hariprasath.elango@gmail.com, aditya.shankar@microchip.com,
        ganesh.krishna@microchip.com, dan.carpenter@oracle.com,
        gehariprasath@gmail.com, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] staging: wilc1000: replace switch statement by simple
 if condition
Message-ID: <20180320120842.GB4033@hariprasath> (sfid-20180320_130853_904587_C7AEE848)
References: <20180320114331.4084-1-hariprasath.elango@gmail.com>
 <20180320114720.GA31253@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180320114720.GA31253@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 20, 2018 at 12:47:21PM +0100, Greg KH wrote:
> On Tue, Mar 20, 2018 at 05:13:31PM +0530, hariprasath.elango@gmail.com wrote:
> > From: HariPrasath Elango <hariprasath.elango@gmail.com>
> > 
> > In this case,there is only a single switch case statement.So replacing
> > by a simple if condition
> > 
> > Signed-off-by: HariPrasath Elango <hariprasath.elango@gmail.com>
> > ---
> >  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 +-------
> >  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> What changed from v1?  Always put that information below the --- line,
> like the kernel documentation asks you to do.
> 
> v3?  :)
> 
> thanks,
> 
> greg k-h

Lesson learned. I will send a v3 with version history included

regards,
hari prasath

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40870 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752805AbcIJN2p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Sep 2016 09:28:45 -0400
Date: Sat, 10 Sep 2016 15:24:41 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jes.Sorensen@redhat.com
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH - FYI - do not apply] staging: Remove rtl8723au driver
Message-ID: <20160910132441.GA5922@kroah.com> (sfid-20160910_152849_115636_2435DE93)
References: <1473510333-26497-1-git-send-email-Jes.Sorensen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1473510333-26497-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 10, 2016 at 08:25:33AM -0400, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> Hi,
> 
> I sent Greg the full version of this patch, removing the old rtl8723au
> driver. I didn't want to spam the list with a 2M+ patch so this is the
> summary version. 
> 
> Cheers,
> Jes
> 
> This driver is superseded by rtl8xxxu and has been marked as scheduled
> for deletion since 4.6

I've now applied this to the staging tree, thanks.

greg k-h

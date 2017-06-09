Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46722 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751801AbdFIJem (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 05:34:42 -0400
Date: Fri, 9 Jun 2017 11:34:24 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 07/11] wireless: ipw2x00: convert to use DRIVER_ATTR_RW
Message-ID: <20170609093424.GA31717@kroah.com> (sfid-20170609_113524_828360_2A10B52E)
References: <20170609090314.13991-1-gregkh@linuxfoundation.org>
 <20170609090314.13991-7-gregkh@linuxfoundation.org>
 <87h8zp4inb.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87h8zp4inb.fsf@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 09, 2017 at 12:25:44PM +0300, Kalle Valo wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 
> > We are trying to get rid of DRIVER_ATTR(), and the ipw2x00 driver's
> > attributes can be trivially changed to use DRIVER_ATTR_RW().
> >
> > Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> > Cc: <linux-wireless@vger.kernel.org>
> > Cc: <netdev@vger.kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Looks good to me. I assume that I should take this, but let me know if
> you are planning to push this via your trees instead. Either way is fine
> for me, I'm not expecting any conflicts here.

I can take it, thanks!

greg k-h

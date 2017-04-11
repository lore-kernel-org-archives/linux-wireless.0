Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51330 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752069AbdDKFRT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 01:17:19 -0400
Date: Tue, 11 Apr 2017 07:17:09 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Bastien Nocera <hadess@hadess.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] staging: rtl8723bs: Add missing include <linux/of.h> to
 fix compile error
Message-ID: <20170411051709.GA9188@kroah.com> (sfid-20170411_071724_304618_CDFD994D)
References: <20170410191307.4137-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170410191307.4137-1-hdegoede@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 10, 2017 at 09:13:07PM +0200, Hans de Goede wrote:
> As reported by Stephen Rothwell when merging staging-next,
> drivers/staging/rtl8723bs/core/rtw_ieee80211.c does not compile due
> to of_get_property not being declared.
> 
> Explicitly include <linux/of.h> to fix this compile error.
> 
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>

You should use "Reported-by:" here in the future...

thanks,

greg k-h

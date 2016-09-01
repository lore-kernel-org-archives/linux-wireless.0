Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53207 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753008AbcIAPmZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2016 11:42:25 -0400
Date: Thu, 1 Sep 2016 17:42:32 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Luca Ceresoli <luca@lucaceresoli.net>
Cc: devel@driverdev.osuosl.org, Jes Sorensen <Jes.Sorensen@redhat.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 1/6] rtl8723au: remove declaration of unimplemented
 functions
Message-ID: <20160901154232.GA19440@kroah.com> (sfid-20160901_174229_252386_75E5414D)
References: <1472301649-18694-1-git-send-email-luca@lucaceresoli.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1472301649-18694-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 27, 2016 at 02:40:44PM +0200, Luca Ceresoli wrote:
> Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Jes Sorensen <Jes.Sorensen@redhat.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/staging/rtl8723au/include/recv_osdep.h | 3 ---
>  1 file changed, 3 deletions(-)

I can't take patches without any changelog text, sorry.  Please fix that
up for all 6 of these patches and resend.

thanks,

greg k-h

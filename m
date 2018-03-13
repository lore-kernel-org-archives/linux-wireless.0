Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42711 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752748AbeCMUSB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 16:18:01 -0400
Date: Wed, 14 Mar 2018 07:17:57 +1100
From: tcharding <me@tobin.cc>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Tycho Andersen <tycho@tycho.ws>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [RESEND] rsi: Remove stack VLA usage
Message-ID: <20180313201757.GK8631@eros> (sfid-20180313_211821_614478_9DC78394)
References: <1520819022-15238-1-git-send-email-me@tobin.cc>
 <20180312094606.8192B6081A@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180312094606.8192B6081A@smtp.codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 12, 2018 at 09:46:06AM +0000, Kalle Valo wrote:
> tcharding <me@tobin.cc> wrote:
> 
> > The kernel would like to have all stack VLA usage removed[1].  rsi uses
> > a VLA based on 'blksize'.  Elsewhere in the SDIO code maximum block size
> > is defined using a magic number.  We can use a pre-processor defined
> > constant and declare the array to maximum size.  We add a check before
> > accessing the array in case of programmer error.
> > 
> > [1]: https://lkml.org/lkml/2018/3/7/621
> > 
> > Signed-off-by: Tobin C. Harding <me@tobin.cc>
> 
> Tobin, your name in patchwork.kernel.org is just "tcharding" then it should be
> "Tobin C. Harding". Patchwork is braindead in a way as it takes the name from
> it's database instead of the From header of the patch in question.
> 
> I can fix that manually but it would be helpful if you could register to
> patchwork and fix your name during registration. You have only one chance to
> fix your name (another braindead feature!) so be careful :)

Hi Kalle,

I logged into my patchwork account but I don't see any way to set the
name.  Within 'profile' there is only 'change password' and 'link
email'.  I thought I could unregister then re-register but I can't see
how to do that either.  Is there a maintainer of patchwork.kernel.org
who I can email to manually remove me from the system?

thanks,
Tobin.

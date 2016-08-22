Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46420 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756005AbcHVOaM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 10:30:12 -0400
Date: Mon, 22 Aug 2016 10:30:20 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: David Binderman <linuxdev.baldrick@gmail.com>
Cc: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dcb314@hotmail.com
Subject: Re:
 linux-4.8-rc3/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c:3533:
 pointless test ?
Message-ID: <20160822143020.GA7695@kroah.com> (sfid-20160822_163033_159236_F7FB2CF9)
References: <CAMzoamY0HSt4af8EeJpt73FD++q1MZ7iHJFa4NDBtzzQrNMjbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMzoamY0HSt4af8EeJpt73FD++q1MZ7iHJFa4NDBtzzQrNMjbg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 22, 2016 at 03:07:44PM +0100, David Binderman wrote:
> Hello there,
> 
> linux-4.8-rc3/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c:3533]:
> (style) Condition 'pBtMgnt.ExtConfig.HCIExtensionVer>=1' is always
> true
> 
> Source code is
> 
>         if (pBtMgnt->ExtConfig.HCIExtensionVer < 1) {
>         ....
>         } else if (pBtMgnt->ExtConfig.HCIExtensionVer >= 1) {
> 
> Suggest remove second test.

patches are always welcome :)

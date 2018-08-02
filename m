Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60810 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbeHBVXy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Aug 2018 17:23:54 -0400
Date: Thu, 2 Aug 2018 21:31:16 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        ganesh.krishna@microchip.com, venkateswara.kaja@microchip.com,
        aditya.shankar@microchip.com, claudiu.beznea@microchip.com,
        adham.abozaeid@microchip.com
Subject: Re: [PATCH] staging: wilc1000: fix compilation warning for ARCH
 PowerPC
Message-ID: <20180802193116.GA27034@kroah.com> (sfid-20180802_213127_717845_998F918A)
References: <1533209222-22295-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1533209222-22295-1-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 02, 2018 at 04:57:02PM +0530, Ajay Singh wrote:
> Fix below warning reported for PowerPC arch compilation
> 
> include/uapi/linux/byteorder/big_endian.h:95:37: warning: passing
> argument 1 of '__swab32s' makes pointer from integer without a cast
> [-Wint-conversion]
> 
> Fixes: 02211edc9a1f ("staging: wilc1000: fix endianness warnings
> reported by sparse")
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---

You forgot the reported-by: line :(

I'll go add it, but be more careful in the future please.

greg k-h

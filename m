Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64319 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759552Ab1EMQjx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 12:39:53 -0400
Received: by pvg12 with SMTP id 12so1223379pvg.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 09:39:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110513160113.GA14293@zenon.in.qult.net>
References: <20110513160113.GA14293@zenon.in.qult.net>
Date: Fri, 13 May 2011 12:39:53 -0400
Message-ID: <BANLkTikiWNXnB6NcS48-1x9KYes_o=omjg@mail.gmail.com> (sfid-20110513_183957_159701_71619D4C)
Subject: Re: WPA in ad-hoc mode with carl9170
From: Brian Prodoehl <bprodoehl@gmail.com>
To: Ignacy Gawedzki <i@lri.fr>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 13, 2011 at 12:01 PM, Ignacy Gawedzki <i@lri.fr> wrote:
> Hi,
>
> I've been trying to setup WPA using wpa_supplicant in an ad-hoc network,
> specifically using AR9170 USB interfaces with the carl9170 driver and
> firmware.
>
> Although wpa_supplicant is supposed to be able to setup a single shared group
> key for all communications, it appears at least the broadcast traffic is
> neither enciphered at the sending end nor received at the receiving end
> (tested with both TKIP and CCMP).
>
> I was wondering whether this is supposed to work or it is just too soon.  If
> there's anything that I could do to contribute, I'd be happy to help.
>
> Thanks.
>
> Ignacy

Have you tested only with hw crypto?  Try passing the nohwcrypt param
to the module while loading.

-Brian

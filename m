Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:33372 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751010AbdGPI6Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Jul 2017 04:58:25 -0400
Received: by mail-wm0-f52.google.com with SMTP id t70so16613446wmt.0
        for <linux-wireless@vger.kernel.org>; Sun, 16 Jul 2017 01:58:25 -0700 (PDT)
Received: from stargate.localnet (87-127-66-237.static.enta.net. [87.127.66.237])
        by smtp.gmail.com with ESMTPSA id g82sm7815987wmg.8.2017.07.16.01.58.22
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Jul 2017 01:58:23 -0700 (PDT)
From: David Goodenough <dfgoodenough@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: Intel 8265/8275 microcode
Date: Sun, 16 Jul 2017 09:58:15 +0100
Message-ID: <2178837.BdKxmf7zyZ@stargate> (sfid-20170716_105843_164049_2BD45FD7)
In-Reply-To: <1500152336.22048.188.camel@coelho.fi>
References: <34104523.kB8OiK1t1Y@stargate> <1500152336.22048.188.camel@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You are right, it was working all along, I just had another config error which
meant that it did not seem to be working.

I followed by usual problem solving which is to look for the first error
message.  Should have looked further. 

thanks for your help

David

On Saturday, 15 July 2017 23:58:56 BST Luca Coelho wrote:
> On Sat, 2017-07-15 at 10:03 +0100, David Goodenough wrote:
> > I have a laptop which reports the wifi adapter to be an 8265/8275 rev 78
> > and the driver complains that it can not find:-
> > 
> > iwlwifi-8265-23.ucode
> > iwlwifi-8265-24.ucode
> > iwlwifi-8265-25.ucode
> > iwlwifi-8265-26.ucode
> > iwlwifi-8265-27.ucode
> > iwlwifi-8265-28.ucode
> > 
> > and they not appear to be in the kernel.org github.  Where do I find
> > them and could they be added to github?
> 
> Does your wifi card work? The driver tries to find one of the supported
> versions, starting from highest and going down to the lowest.  It seems
> that you have -22.ucode and, if that's the case, everything should be
> fine and you can ignore these messages.
> 
> It is an old known problem that there is no way to try to load a
> firmware without getting an error message.  People are working on
> solving this, but until then, just ignore this messages and everything
> should be fine. :)
> 
> --
> Cheers,
> Luca.

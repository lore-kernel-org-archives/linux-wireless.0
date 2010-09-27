Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61610 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab0I0XCP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 19:02:15 -0400
Received: by gxk9 with SMTP id 9so1713998gxk.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 16:02:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <F2D55DC7DDE6443EA6E69CBBE698A335@ChuckPC>
References: <58E3CFACA7054DC48245C67E9D4AE07B@ChuckPC> <AANLkTim=hHPMS9kUn11BnWDED1DeUVdJmu3u0Ajr3MPa@mail.gmail.com>
 <F2D55DC7DDE6443EA6E69CBBE698A335@ChuckPC>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 27 Sep 2010 16:01:54 -0700
Message-ID: <AANLkTi=Sm_L+G9JXCuHJhzZm255EtHupkQ1YGy3wpuy3@mail.gmail.com>
Subject: Re: memory leak in scan with 9170?
To: Chuck Crisler <ccrisler@vgocom.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 27, 2010 at 3:40 PM, Chuck Crisler <ccrisler@vgocom.com> wrote:
> Well, (as usual) I was wrong. It isn't a memory problem. It seems that after
> some indeterminant time, the USB interface locks up. When we try to take it
> down (ifconfig wlan0 down) we get a message about outstanding urbs. By
> powering down the 9170 we can re-set the device and get it to re-associate
> and resume work. So, the problem is a USB problem. The question is if it is
> a module problem or a system problem. We are typically seeing this after
> 50-200 reassociations. If we don't reassociate, it doesn't seem to occur.
> Does anyone else have experience or insight into this?

Upgrade.

  Luis

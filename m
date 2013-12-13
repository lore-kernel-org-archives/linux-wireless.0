Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:58440 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab3LMDJP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 22:09:15 -0500
Received: by mail-ea0-f171.google.com with SMTP id h10so599656eak.2
        for <linux-wireless@vger.kernel.org>; Thu, 12 Dec 2013 19:09:14 -0800 (PST)
Message-ID: <52AA7A57.9090902@gmail.com> (sfid-20131213_040918_914519_C91371ED)
Date: Fri, 13 Dec 2013 05:09:11 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: David Williams <xflow7@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Microcode crashes on Intel 7260
References: <CANUDGG3bU9PkQgZYKFYAb31sN7xzvtAM0+xsasXpSgR5Q1CmHw@mail.gmail.com>
In-Reply-To: <CANUDGG3bU9PkQgZYKFYAb31sN7xzvtAM0+xsasXpSgR5Q1CmHw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12/12/2013 10:38 PM, David Williams wrote:
> Hello,
> 
> I am a victim of the bug causing microcode crashes on Intel 7260.  I
> understand that new firmware is in the works that should resolve this.  I
> have two questions:

Please share iw list output and dmesg output

> 
> 1) Is there any indication as to whether the new firmware/driver will make
> it into the 3.10 or 3.12 kernels?
> 

It is most probably a firmware issue - I'll know after you send the
output I mentioned above.

> 2) Is there a workaround using the existing firmware in the meantime?
> 

I am not aware of any microcode error we can workaround in the driver.
But you might be facing an issue I have never seen - please send the
output and we'll see.

> Thanks,
> 
> Dave Williams
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

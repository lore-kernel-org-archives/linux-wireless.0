Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:12996 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbYDBPaG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 11:30:06 -0400
Received: by nf-out-0910.google.com with SMTP id g13so1162157nfb.21
        for <linux-wireless@vger.kernel.org>; Wed, 02 Apr 2008 08:30:04 -0700 (PDT)
Message-ID: <47F3A67B.1040909@gmail.com> (sfid-20080402_163011_811536_EC872CE1)
Date: Wed, 02 Apr 2008 17:30:03 +0200
From: Luca Venturini <lucventurini@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: New IWL4935 driver for Intel Wireless Cards does not support
 WPA2 wireless network with PEAP - MSCHAPV2
References: <adKlV-3WV-5@gated-at.bofh.it> <adS9O-4u9-1@gated-at.bofh.it> <adUY2-379-7@gated-at.bofh.it> <adVUj-5bx-81@gated-at.bofh.it> <47F38267.2040301@fenrir.org.uk>
In-Reply-To: <47F38267.2040301@fenrir.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(I hope I am not making again something rude posting here, and if this 
is the case, I apologize; I am sorry, but this is the first time ever I 
write directly to Linux developers, and I am unsure of how to behave.)

I thank everybody for your help and understanding. I will try to contact 
Ubuntu developers and ask about current situation for this issue. In the 
meantime, Filippo Zangheri of the Linux team was so kind as to give me 
detailed instructions on how to install the latest modules for intel 
wireless cards, so hopefully I will patch the problem well enough so to 
actually update my box...and see if developers have indeed addressed the 
problem in the meantime.

Thank you again, and keep up the awesome work!

Luca Venturini

Brian Morrison ha scritto:
> Luca Venturini wrote:
>> I hope, then, that Linux 2.6.25.x stable will be out sooner than 24th 
>> april (Hardy release date) otherwise I (and I guess also many other 
>> people) will be in a very bad spot until the kernel is updated...(I 
>> am not proficient enough so to compile a whole Linux kernel for my 
>> distro).
>
> I don't know about the Ubuntu situation, but in Fedora the current 
> 2.6.24.x series kernels work just fine with the iwlwifi driver and 
> 3945 and 4965 chipset firmware. Much of the 2.6.25 wireless changes 
> are already in the Fedora kernels (that's where a lot of testing 
> happens) and there is no reason that the Ubuntu maintainers cannot do 
> the same thing. Testing of these changes and discussion of same occurs 
> on the linux-wireless list, if you're seeing problems this is a good 
> place to ask for help. I don't use PEAP with MSCHAPV2 myself, but I 
> did see something on the NetworkManager mailing list from Bill Moss at 
> Clemson University who has got some sort of certificate authentication 
> working under Fedora (might be PEAP), you can probably find his post 
> with help from Google.
>
> I'd suggest asking the Ubuntu team what the status is for this issue 
> and if they have any test kernels to try. The kernel ML is not a good 
> place since they are concerned with the vanilla release and not with 
> any distro specific changes. Linux wireless is under heavy development 
> and 2.6.25 vanilla is the first release where anything like working 
> code will appear from Linus, but the same code has been in the distros 
> fro some time as they need to provide people with a working environment.
>
> HTH :)
>


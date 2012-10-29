Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35749 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933286Ab2J2Vv3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 17:51:29 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so7320971iea.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Oct 2012 14:51:28 -0700 (PDT)
Message-ID: <508EFA5D.8090706@lwfinger.net> (sfid-20121029_225143_276764_D866E8DB)
Date: Mon, 29 Oct 2012 16:51:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Cliff McDiarmid <cliffhanger@gardener.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8188SU
References: <loom.20121028T233054-8@post.gmane.org> <201210291257.02249.chunkeey@googlemail.com> <loom.20121029T182405-382@post.gmane.org> <201210292117.45399.chunkeey@googlemail.com> <loom.20121029T214630-424@post.gmane.org>
In-Reply-To: <loom.20121029T214630-424@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/29/2012 04:11 PM, Cliff McDiarmid wrote:
> Christian Lamparter <chunkeey@...> writes:
>
>
>>> but could I revert?
>> Well, this is getting confusing ;)
>> Can you explain what you want reverted?
>>
>> Regards,
>
> Sorry probably bad english.   I was wondering if I revert to using the 'old'
> driver, 8192u, with the rtl8188su and you seem to suggest yes?   However, I have
> the 8192u module built in the kernel at present and it will not load when the
> rtl8188su is plugged in.

The "old" driver for the RTL8188SU is r8712u, not 8192u. The USB_DEVICE table 
for 8192u is:

         {USB_DEVICE(0x0bda, 0x8709)},
         {USB_DEVICE(0x07aa, 0x0043)},
         {USB_DEVICE(0x050d, 0x805E)},
         {USB_DEVICE(0x0df6, 0x0031)},
         {USB_DEVICE(0x1740, 0x9201)},
         {USB_DEVICE(0x2001, 0x3301)},
         {USB_DEVICE(0x5a57, 0x0290)},
         {USB_DEVICE(0x043e, 0x7a01)},

I have an extensive collection of Realtek devices; however, I have never seen 
any of these.

Larry



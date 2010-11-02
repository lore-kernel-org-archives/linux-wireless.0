Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58677 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab0KBXsV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 19:48:21 -0400
Received: by vws13 with SMTP id 13so338524vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Nov 2010 16:48:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CCF7EFC.1050000@mandriva.com.br>
References: <309278.75116.qm@web29520.mail.ird.yahoo.com>
	<4CCF7B73.7040906@lwfinger.net>
	<4CCF7EFC.1050000@mandriva.com.br>
Date: Tue, 2 Nov 2010 21:48:20 -0200
Message-ID: <AANLkTinEsp+-EU4Oau71qHbL6ftO544+H4GA3WZk7CX5@mail.gmail.com>
Subject: Re: [PATCH 3/9] rtl8187: fix wrong register initialization in 8187B
From: Rogerio Luz Coelho <rogluz.news@gmail.com>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, I see the 8187b is in development.

But PLEASE ask Thadeu Cascardo for his patch as it seems to fix the
issue with these cards when connected to Laptop (Positivo Laptops in
Brasil for instance), this would even let the Mandriva folks show
Positivo that they don't need to ship the Mandriva 2008.0 woith their
Linux Laptops anymore ...

the patch he sent me FIXED the problem where the chip did not connect
or when it did it would lose the connection right away...

see
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/215802?comments=all


I haven´t aplied any other patches and the one he sent me JUST WORKS,
tested in a Ubuntu 10.04 64bit (64bit being important since the
Realtek support told me they did NOT support 64bit with their linux
drivers)

Thanks

Rogerio

2010/11/2 Herton Ronaldo Krzesinski <herton@mandriva.com.br>:
> On 02-11-2010 00:46, Larry Finger wrote:
>>
>> On 11/01/2010 09:42 PM, Hin-Tak Leung wrote:
>>>
>>> --- On Tue, 2/11/10, Herton Ronaldo Krzesinski<herton@mandriva.com.br>
>>>  wrote:
>>>
>>>> We were using wrong address for BRSR
>>>> (Basic Rate Set Register) while
>>>> initializing its value, comparing with Realtek sources, for
>>>> 8187B case.
>>>>
>>>> Also, the same register is initialized in
>>>> rtl8187b_reg_table, so remove
>>>> the duplicate initialization from the table.
>>>>
>>>> Signed-off-by: Herton Ronaldo Krzesinski<herton@mandriva.com.br>
>>>> Acked-by: Larry Finger<Larry.Finger@lwfinger.net>
>>>
>>> Acked-by: Hin-Tak Leung<htl10@users.sourceforge.net>
>>>
>>> ANAPARAM* stands for "anonymous parameters", right?  One of these days we
>>> should give them some meaningful names.
>>
>> I have always thought it was for "analog parameter". Am I wrong?
>
> Nope, you're right, its listed description is "analog parameter" in 8180
> spec.
>
>>
>> Larry
>
> --
> []'s
> Herton
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

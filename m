Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([187.115.55.249]:52164 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424Ab0KBDBd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 23:01:33 -0400
Message-ID: <4CCF7EFC.1050000@mandriva.com.br>
Date: Tue, 02 Nov 2010 01:01:16 -0200
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: htl10@users.sourceforge.net, linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 3/9] rtl8187: fix wrong register initialization in 8187B
References: <309278.75116.qm@web29520.mail.ird.yahoo.com> <4CCF7B73.7040906@lwfinger.net>
In-Reply-To: <4CCF7B73.7040906@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02-11-2010 00:46, Larry Finger wrote:
> On 11/01/2010 09:42 PM, Hin-Tak Leung wrote:
>>
>> --- On Tue, 2/11/10, Herton Ronaldo Krzesinski<herton@mandriva.com.br>  wrote:
>>
>>> We were using wrong address for BRSR
>>> (Basic Rate Set Register) while
>>> initializing its value, comparing with Realtek sources, for
>>> 8187B case.
>>>
>>> Also, the same register is initialized in
>>> rtl8187b_reg_table, so remove
>>> the duplicate initialization from the table.
>>>
>>> Signed-off-by: Herton Ronaldo Krzesinski<herton@mandriva.com.br>
>>> Acked-by: Larry Finger<Larry.Finger@lwfinger.net>
>>
>> Acked-by: Hin-Tak Leung<htl10@users.sourceforge.net>
>>
>> ANAPARAM* stands for "anonymous parameters", right?  One of these days we should give them some meaningful names.
>
> I have always thought it was for "analog parameter". Am I wrong?

Nope, you're right, its listed description is "analog parameter" in 8180 
spec.

>
> Larry

--
[]'s
Herton

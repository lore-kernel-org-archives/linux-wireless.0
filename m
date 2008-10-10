Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:1499 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760221AbYJJVUA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 17:20:00 -0400
Received: by nf-out-0910.google.com with SMTP id d3so359515nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2008 14:19:58 -0700 (PDT)
Message-ID: <48EFC6FB.7060408@gmail.com> (sfid-20081010_232009_005886_7EEE3FB5)
Date: Fri, 10 Oct 2008 22:19:55 +0100
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@newmail.ru>
CC: orinoco-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: rc9 + orinoco WPA patchset: BUG: scheduling while atomic loading
 firmware with PCMCIA adapter
References: <200810091722.56812.arvidjaar@newmail.ru> <200810102114.55663.arvidjaar@newmail.ru> <48EF8E01.2060709@gmail.com> <200810102126.32246.arvidjaar@newmail.ru>
In-Reply-To: <200810102126.32246.arvidjaar@newmail.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Borzenkov wrote:
> On Friday 10 October 2008, Dave wrote:
>> Andrey Borzenkov wrote:
>>> On Friday 10 October 2008, Dave wrote:
>>>> You're right. pda_size is supposed to be the maximum size of the PDA (in bytes) that we expect with the firmware. It should be set to 0x200.
>>>>
>>> Do you want me to send a patch?
>> Could you fix it as part of the patch you submitted?
>>
> 
> Attached. As other entries use decimal I thought it is more logical
> to use 512 as well.

ACK.


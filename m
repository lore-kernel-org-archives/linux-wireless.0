Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:28343 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759340AbYJJRQz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 13:16:55 -0400
Received: by ey-out-2122.google.com with SMTP id 6so257142eyi.37
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2008 10:16:53 -0700 (PDT)
Message-ID: <48EF8E01.2060709@gmail.com> (sfid-20081010_191659_654891_C6DC85AA)
Date: Fri, 10 Oct 2008 18:16:49 +0100
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@newmail.ru>
CC: Dave <kilroyd@googlemail.com>, orinoco-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: rc9 + orinoco WPA patchset: BUG: scheduling while atomic loading
 firmware with PCMCIA adapter
References: <200810091722.56812.arvidjaar@newmail.ru> <200810101141.38929.arvidjaar@newmail.ru> <48EF8AF4.1040900@gmail.com> <200810102114.55663.arvidjaar@newmail.ru>
In-Reply-To: <200810102114.55663.arvidjaar@newmail.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Borzenkov wrote:
> On Friday 10 October 2008, Dave wrote:
>> You're right. pda_size is supposed to be the maximum size of the PDA (in bytes) that we expect with the firmware. It should be set to 0x200.
>>
> 
> Do you want me to send a patch?

Could you fix it as part of the patch you submitted?


Regards,

Dave.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:49133 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbaDEGXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2014 02:23:24 -0400
Received: by mail-ob0-f169.google.com with SMTP id va2so4509244obc.14
        for <linux-wireless@vger.kernel.org>; Fri, 04 Apr 2014 23:23:23 -0700 (PDT)
Message-ID: <533FA159.4030300@lwfinger.net> (sfid-20140405_082353_872633_69DA45AC)
Date: Sat, 05 Apr 2014 01:23:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>,
	Andrea Merello <andrea.merello@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com
Subject: Re: [PATCH 1/4] rtl8180: change module name in rtl818Xpci
References: <1396628142-14351-1-git-send-email-andrea.merello@gmail.com> <87bnwgif9n.fsf@purkki.adurom.net>
In-Reply-To: <87bnwgif9n.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/04/2014 11:14 PM, Kalle Valo wrote:
> Andrea Merello <andrea.merello@gmail.com> writes:
>
>> From: Larry Finger <Larry.Finger@lwfinger.net>
>>
>> rtl8180 driver can handle also rtl8185 and rtl8187SE cards,
>> however in userspace tools (network manager) it still appares
>> as "rtl8180".
>> This might lead the user to think the wrong driver is in use.
>>
>> This patch changes module name to "rtl818Xpci" that should be
>> more explanatory.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
>
> [...]
>
>> -obj-$(CONFIG_RTL8180)	+= rtl8180.o
>> +obj-$(CONFIG_RTL8180)	+= rtl818Xpci.o
>
> Aren't module names usually all lower case?

I do not feel strongly about this, but when I viewed the driver name in the KDE 
applet for NetworkManager, the lower-case x sort of got lost, whereas the 
upper-case one stood out. That was the reason for the way I wrote the patch the 
way I did. In a terminal, the lc value looks OK. Perhaps I should have made it 
rtl818x_pci.

Larry



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42068 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912Ab0LIOGK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 09:06:10 -0500
Received: by qwa26 with SMTP id 26so2647033qwa.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Dec 2010 06:06:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1127342.1291773334294.JavaMail.root@elwamui-rubis.atl.sa.earthlink.net>
References: <1127342.1291773334294.JavaMail.root@elwamui-rubis.atl.sa.earthlink.net>
Date: Thu, 9 Dec 2010 15:06:09 +0100
Message-ID: <AANLkTimvWbag5N1XdMN7urwXqnU9b_FNd4fKfbexX=oh@mail.gmail.com>
Subject: Re: [PATCH 1/4] b43: N-PHY: update init tables
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: ikorot@earthlink.net
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/12/8  <ikorot@earthlink.net>:
> Larry,
>
>
> -----Original Message-----
>>From: Larry Finger <Larry.Finger@lwfinger.net>
>>Sent: Dec 7, 2010 12:00 PM
>>To: ikorot@earthlink.net
>>Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
>>Subject: Re: [PATCH 1/4] b43: N-PHY: update init tables
>>
>>On 12/07/2010 01:49 PM, ikorot@earthlink.net wrote:
>>>> One reason is that these tables changed from non-zero to zero values between
>>>> Broadcom driver 4.174.64.19 and 5.10.56.46. As they might change again, I think
>>>> we should retain the full version.
>>>
>>> Is there a way to check for version of the driver?
>>> This way whoever uses old one won't be screwed...
>>
>>That will not be a problem as no older version of b43 works at all with b43. To
>>help you understand this change, when the 4.174.64.19 Broadcom driver was
>>reverse-engineered, the tables had non-zero values. Rafel later compared the
>>trace dumps of b43 with the latest version of wl and found that the values are
>>now zero. When I rechecked driver 5.10.56.46, I found them to be zero there as
>>well and changed the specs.
>
> Well, it maybe feasible to keep the old values and check
> the version of the driver, since you are saying yourself
> that the value might be changing in the future.
> Maybe for couple of releases only?

Sorry, but I don't understand that at all. What do you mean by version
of the driver? What driver?

b43 comes with tables built in, there is no way b43 could use tables
from other version of b43...

-- 
Rafał

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from elasmtp-banded.atl.sa.earthlink.net ([209.86.89.70]:50661 "EHLO
	elasmtp-banded.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932123Ab0LHB4x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 20:56:53 -0500
Message-ID: <1127342.1291773334294.JavaMail.root@elwamui-rubis.atl.sa.earthlink.net>
Date: Tue, 7 Dec 2010 17:55:33 -0800 (GMT-08:00)
From: ikorot@earthlink.net
Reply-To: ikorot@earthlink.net
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 1/4] b43: N-PHY: update init tables
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry,


-----Original Message-----
>From: Larry Finger <Larry.Finger@lwfinger.net>
>Sent: Dec 7, 2010 12:00 PM
>To: ikorot@earthlink.net
>Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
>Subject: Re: [PATCH 1/4] b43: N-PHY: update init tables
>
>On 12/07/2010 01:49 PM, ikorot@earthlink.net wrote:
>>> One reason is that these tables changed from non-zero to zero values between
>>> Broadcom driver 4.174.64.19 and 5.10.56.46. As they might change again, I think
>>> we should retain the full version.
>> 
>> Is there a way to check for version of the driver?
>> This way whoever uses old one won't be screwed...
>
>That will not be a problem as no older version of b43 works at all with b43. To
>help you understand this change, when the 4.174.64.19 Broadcom driver was
>reverse-engineered, the tables had non-zero values. Rafel later compared the
>trace dumps of b43 with the latest version of wl and found that the values are
>now zero. When I rechecked driver 5.10.56.46, I found them to be zero there as
>well and changed the specs.

Well, it maybe feasible to keep the old values and check
the version of the driver, since you are saying yourself
that the value might be changing in the future.
Maybe for couple of releases only?

Thank you.
>
>Larry


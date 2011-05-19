Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36408 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323Ab1ESXHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 19:07:12 -0400
Received: by gwaa18 with SMTP id a18so1122282gwa.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2011 16:07:12 -0700 (PDT)
Message-ID: <4DD5A29D.2060609@lwfinger.net> (sfid-20110520_010717_122700_591A03AB)
Date: Thu, 19 May 2011 18:07:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: John W Linville <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Fix bogus compilation warning for phy_n
References: <4dd58d39.ev8WALmbdvCfJmAJ%Larry.Finger@lwfinger.net>	<BANLkTinDciqW2yJLpwKemnSM=8_1Jy3Fxw@mail.gmail.com>	<4DD595C9.105@lwfinger.net>	<BANLkTi=P-uCzunSyjf2ziX6BaCyq9Muj+g@mail.gmail.com>	<4DD59E2A.4070405@lwfinger.net> <BANLkTi=Mepan9vObhminTdAf9iaO6qmBqA@mail.gmail.com>
In-Reply-To: <BANLkTi=Mepan9vObhminTdAf9iaO6qmBqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/19/2011 05:59 PM, Rafał Miłecki wrote:
> W dniu 20 maja 2011 00:48 użytkownik Larry Finger
>> You are correct. I missed the level of indent in line 3256. What
>> initialization should be used for last?  It clearly needs to be set to
>> something.
>
> http://bcm-v4.sipsolutions.net/802.11/PHY/N/CalTxIqlo does not say
> anything about initial value. Guess it should be zero.

I checked the reference driver. It should be zero. The specs are updated.

Larry

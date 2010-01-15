Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f224.google.com ([209.85.217.224]:57949 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab0AOAOS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 19:14:18 -0500
Received: by gxk24 with SMTP id 24so53393gxk.1
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 16:14:17 -0800 (PST)
Message-ID: <4B4FB34D.7020003@lwfinger.net>
Date: Thu, 14 Jan 2010 18:14:05 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: Re: [PATCH 3/6] b43: N-PHY: add update TX cal ladder
References: <op.u6jn12l09lhzdc@linux-g0th.site> <43e72e891001141508ndec9aeak46412482b2486054@mail.gmail.com> 	<b170af451001141513p6452cf52q6d97477a38e83f34@mail.gmail.com> 	<43e72e891001141544n75de8362ke1756882ed1c2391@mail.gmail.com> 	<b170af451001141552k227a8125nf4926adbfd6d3c8f@mail.gmail.com> <43e72e891001141559n43ce0eecm2894da7fd1409408@mail.gmail.com>
In-Reply-To: <43e72e891001141559n43ce0eecm2894da7fd1409408@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/14/2010 05:59 PM, Luis R. Rodriguez wrote:
> 2010/1/14 Rafał Miłecki <zajec5@gmail.com>:
>>
>> So definitely I will avoid putting just function names. However as I
>> said, I don't think I will be able to be more descriptive :/
> 
> Heh well I had to try :)

Unfortunately, there are no comments in MIPS binary code. Without them, there is
very little more than the function names available.

Larry

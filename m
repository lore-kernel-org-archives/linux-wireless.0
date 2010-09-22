Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44057
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164Ab0IVQWd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 12:22:33 -0400
Date: Wed, 22 Sep 2010 09:22:52 -0700 (PDT)
Message-Id: <20100922.092252.116390431.davem@davemloft.net>
To: chunkeey@googlemail.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2010-09-21
From: David Miller <davem@davemloft.net>
In-Reply-To: <201009221158.13806.chunkeey@googlemail.com>
References: <20100921201705.GC2448@tuxdriver.com>
	<20100921.183614.245388137.davem@davemloft.net>
	<201009221158.13806.chunkeey@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Christian Lamparter <chunkeey@googlemail.com>
Date: Wed, 22 Sep 2010 11:58:13 +0200

> On Wednesday 22 September 2010 03:36:14 David Miller wrote:
>> From: "John W. Linville" <linville@tuxdriver.com>
>> Date: Tue, 21 Sep 2010 16:17:05 -0400
>> 
>> Pulled, but I suspect the 'packed' attribute usage is wrong in
>> ath/carl9170 and can just be deleted.
> 
> which __packed do you think can be removed?
> 
> Note:
> The overzealous use of __packed is a result of a report from Al Viro
> for ar9170usb: "arm will pad even between u8's".

Then only the structure that has the "u8's" needs the __packed attribute
not every single other structure it is included in.

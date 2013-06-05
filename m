Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55672 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756134Ab3FEOqT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 10:46:19 -0400
Received: from mailout-de.gmx.net ([10.1.76.12]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0Lhhfz-1U6YYt0o7t-00mrzm for
 <linux-wireless@vger.kernel.org>; Wed, 05 Jun 2013 16:46:18 +0200
Message-ID: <51AF4F35.50503@rempel-privat.de> (sfid-20130605_164622_369906_3ED00354)
Date: Wed, 05 Jun 2013 16:46:13 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@blackshift.org>
CC: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH] ath9k_htc: fix skb_under_panic error
References: <51ADBC01.6090202@blackshift.org> <1370371064-6903-1-git-send-email-linux@rempel-privat.de> <CAGXE3d9p7zkwfNJBJvPMc8XaKnb009pHpCXYweDjK4tv6PCkuA@mail.gmail.com> <51AF4AA7.6050005@blackshift.org>
In-Reply-To: <51AF4AA7.6050005@blackshift.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 05.06.2013 16:26, schrieb Marc Kleine-Budde:
> On 06/05/2013 04:24 PM, Helmut Schaa wrote:
>> On Tue, Jun 4, 2013 at 8:37 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
>>> This error seems to be really rare, and we do not know real couse of it.
>>> But, in any case, we should check size of head before reducing it.
>>
>> Mind to try the (completely untested) patch against wireless-testing instead?
>> Helmut
>
> I will do, however I'm not in range of that USB wireless adapter for
> about 1,5 weeks.

Helmut, thank you for patch!

i'll do regression test, but not week long test. So i probably won't 
reproduce this issue.


-- 
Regards,
Oleksij

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41455 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594Ab2EPUhL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 16:37:11 -0400
Message-ID: <4FB40FF0.4050809@hauke-m.de> (sfid-20120516_223716_008251_1D472FFC)
Date: Wed, 16 May 2012 22:37:04 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
CC: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>,
	mcgrof@kernel.org, linux-wireless@vger.kernel.org,
	lf_driver_backport@lists.linux-foundation.org,
	linux-bluetooth@vger.kernel.org
Subject: Re: [Lf_driver_backport] [PATCH] compat: backport ether_addr_equal
References: <1337162148-16499-1-git-send-email-ozancag@gmail.com> <CAB=NE6W2dz=Ld=w5+7jexKk9xfADhk644mc4C=TtbvBZ9_cKGg@mail.gmail.com>
In-Reply-To: <CAB=NE6W2dz=Ld=w5+7jexKk9xfADhk644mc4C=TtbvBZ9_cKGg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/16/2012 10:17 PM, Luis R. Rodriguez wrote:
> On Wed, May 16, 2012 at 2:55 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
>> This backports:
>>
>>    commit a599b0f54d233d0f63d6be9a2ff0049d24751669
>>    Author: Joe Perches <joe@perches.com>
>>    Date:   Tue May 8 18:56:45 2012 +0000
>>
>>        etherdevice.h: Add ether_addr_equal
>>
>>        Add a boolean function to check if 2 ethernet addresses
>>        are the same.
>>
>>        This is to avoid any confusion about compare_ether_addr
>>        returning an unsigned, and not being able to use the
>>        compare_ether_addr function for sorting ala memcmp.
>>
>>        Signed-off-by: Joe Perches <joe@perches.com>
>>        Signed-off-by: David S. Miller <davem@davemloft.net>
>>
>> [root@ozzyfedora compat]# bin/ckmake
>> Trying kernel                      3.3.4-5.fc17.x86_64  [OK]
>>
>> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
> 
> Thanks!! BTW I see this though:
> 
> Content-Type: text/plain; charset="utf-8"
> Content-Transfer-Encoding: base64
> 
> And then all I see is this when I save the e-mail to a txt file, given
> that the encoding is base64. This is odd given that I see you sent
> this with X-Mailer: git-send-email 1.7.10.1 -- so not sure how this
> ended up going out like this.

That's strange, when I save this mail I got over the mailing list with
Thunderbird it is not based64 encoded and when looking into the source
code with my mail program it is normal text mail.

From:	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH] compat: backport ether_addr_equal
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hauke

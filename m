Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from r-mail2.rd.orange.com ([217.108.152.42]:22388 "EHLO
	r-mail2.rd.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab3GIPAr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 11:00:47 -0400
Message-ID: <51DC259D.9010505@Free.fr> (sfid-20130709_170050_305865_BA7F04D1)
Date: Tue, 09 Jul 2013 17:00:45 +0200
From: Eric Valette <Eric.Valette@Free.fr>
Reply-To: Eric.Valette@Free.fr
MIME-Version: 1.0
To: Eric.Valette@Free.fr, Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: ralink 3290: still lots of misc errors reported by Iwconfig with
 3.10 + HD streaming on WiFi fails
References: <51DBEB0C.6040704@Free.fr> <20130709142202.GB3681@redhat.com> <51DC1F9D.7000705@Free.fr>
In-Reply-To: <51DC1F9D.7000705@Free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/09/2013 04:35 PM, Eric Valette wrote:

>> Do you mean that 3.10 perform better than 3.9.9 ? I do not see any
>> rt2x00 fixes between 3.9 and 3.10 that are not yet applied on 3.9.9.
>> I can see only some cleanups and new hardware support patches.
>
>  From memory I think I had a lot of reported TX error with 3.9.9 and
> they are now gone with 3.10 but the number of misc error reported by
> iwconfig is still high with 3.10. But you are right the fix for TX is
> still in wireless git and does not seem to be in 3.10. As I checked
> several git trees I mist have been confused...

Unless I'm really tired, this patch is in 3.10 and not in 3.9.9 :

http://git.kernel.org/cgit/linux/kernel/git/linville/wireless-testing.git/patch/drivers/net/wireless/rt2x00?id=8857d6dc77e4e3afeee2f33c49597010130ed858


--eric


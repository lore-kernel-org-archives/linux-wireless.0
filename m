Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61871 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933087Ab2GDBFh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 21:05:37 -0400
Received: by wibhm11 with SMTP id hm11so4925485wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jul 2012 18:05:36 -0700 (PDT)
Message-ID: <4FF396DD.7060408@gmail.com> (sfid-20120704_030543_869105_B33F3E37)
Date: Wed, 04 Jul 2012 03:05:33 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
CC: linville@tuxdriver.com, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wireless-regdb: Update regulatory rules for ES (Spain)
 on 5GHz and 2.4GHz
References: <1341362473-18747-1-git-send-email-xose.vazquez@gmail.com> <CAB=NE6U=bk6RSXHouuHvJd0=GErYJp82jkgeNWGnPDooZ_SONQ@mail.gmail.com>
In-Reply-To: <CAB=NE6U=bk6RSXHouuHvJd0=GErYJp82jkgeNWGnPDooZ_SONQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/04/2012 02:49 AM, Luis R. Rodriguez wrote:
> On Tue, Jul 3, 2012 at 5:41 PM, Xose Vazquez Perez
> <xose.vazquez@gmail.com> wrote:

>>   country ES: DFS-ETSI
>> -       (2402 - 2482 @ 40), (N/A, 20)
>> -       (5170 - 5250 @ 40), (N/A, 20)
>> -       (5250 - 5330 @ 40), (N/A, 20), DFS
>> -       (5490 - 5710 @ 40), (N/A, 27), DFS
>> +       (2400 - 2483.5 @ 40), (N/A, 100 mW)
>> +       (5150 - 5250 @ 40), (N/A, 100 mW), NO-OUTDOOR
>> +       (5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
>> +       (5470 - 5725 @ 40), (N/A, 500 mW), DFS

> You are changing from dBm to mW directly... please do the unit change
> in one patch and *then* the actual change. This would make it easier
> to review....

I did copy & paste from DE to ES. These are basic CEPT rules.

10 log(100) = 20
10 log(500) ~ 27

Anyway tomorrow, I will send a new patch.

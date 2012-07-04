Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2811 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932801Ab2GDGBl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 02:01:41 -0400
Message-ID: <4FF3DC31.2030004@broadcom.com> (sfid-20120704_080149_954003_36D3EAB7)
Date: Wed, 4 Jul 2012 08:01:21 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Xose Vazquez Perez" <xose.vazquez@gmail.com>
cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>, linville@tuxdriver.com,
	wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wireless-regdb: Update regulatory rules for ES
 (Spain) on 5GHz and 2.4GHz
References: <1341362473-18747-1-git-send-email-xose.vazquez@gmail.com>
 <CAB=NE6U=bk6RSXHouuHvJd0=GErYJp82jkgeNWGnPDooZ_SONQ@mail.gmail.com>
 <4FF396DD.7060408@gmail.com>
In-Reply-To: <4FF396DD.7060408@gmail.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/04/2012 03:05 AM, Xose Vazquez Perez wrote:
> On 07/04/2012 02:49 AM, Luis R. Rodriguez wrote:
>> On Tue, Jul 3, 2012 at 5:41 PM, Xose Vazquez Perez
>> <xose.vazquez@gmail.com> wrote:
> 
>>>   country ES: DFS-ETSI
>>> -       (2402 - 2482 @ 40), (N/A, 20)
>>> -       (5170 - 5250 @ 40), (N/A, 20)
>>> -       (5250 - 5330 @ 40), (N/A, 20), DFS
>>> -       (5490 - 5710 @ 40), (N/A, 27), DFS
>>> +       (2400 - 2483.5 @ 40), (N/A, 100 mW)
>>> +       (5150 - 5250 @ 40), (N/A, 100 mW), NO-OUTDOOR
>>> +       (5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
>>> +       (5470 - 5725 @ 40), (N/A, 500 mW), DFS
> 
>> You are changing from dBm to mW directly... please do the unit change
>> in one patch and *then* the actual change. This would make it easier
>> to review....
> 
> I did copy & paste from DE to ES. These are basic CEPT rules.
> 
> 10 log(100) = 20
> 10 log(500) ~ 27
> 
> Anyway tomorrow, I will send a new patch.

Just a general remark not specific to this patch. The commit message
often contains a source reference. I think it would be useful to have
this reference in the database a well so people validating it do not
need to do the digging using 'git blame'. Does that make sense?

Gr. AvS


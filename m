Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57670 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab0IRSvh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Sep 2010 14:51:37 -0400
Message-ID: <4C950A22.6050105@candelatech.com>
Date: Sat, 18 Sep 2010 11:51:14 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Bruno Randolf <br1@einfach.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: wireless-testing or wireless-next
References: <201009171148.39953.br1@einfach.org> <AANLkTinYo5qgXvSnQSHpLbhhBq0VG7Kh-X3dGK8NhXcj@mail.gmail.com>
In-Reply-To: <AANLkTinYo5qgXvSnQSHpLbhhBq0VG7Kh-X3dGK8NhXcj@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/16/2010 08:02 PM, Luis R. Rodriguez wrote:
> On Thu, Sep 16, 2010 at 7:48 PM, Bruno Randolf<br1@einfach.org>  wrote:
>> John, Luis,
>>
>> I'm a little confused about which tree to use. I though we should base driver
>> development on wireless-testing, but I see that you merge patches into
>> wireless-next first. So should we re-base patches to wireless-next before we
>> send them?
>
> Rule of thumb is if its large use linux-next, wireless-testing just
> lets you actually boot a usable kernel.

I saw what looked like a nice series of patches from you four days ago
(power save, etc).  But, they have not been applied to wireless-testing.

Is there a tree that does contain these sorts of patches, or must
we manually apply them to our own trees if we want to try them out?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

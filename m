Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:51312 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaFXIIA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 04:08:00 -0400
Received: by mail-yk0-f176.google.com with SMTP id 131so5374322ykp.21
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 01:07:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53A92ACB.8080005@gmail.com>
References: <CAAnNoB_8MSR3S+VmFJUKKU4bO5zfeu1N_4-vQULqBf1_UbAqkg@mail.gmail.com>
	<20140624005030.GI1390@garbanzo.do-not-panic.com>
	<53A92ACB.8080005@gmail.com>
Date: Tue, 24 Jun 2014 10:07:59 +0200
Message-ID: <CAAnNoB80cfdKhnotpQq4Kiu3+=b7K_MEWs-69qh8Pm5Us_YL2A@mail.gmail.com> (sfid-20140624_100806_871921_08683F9D)
Subject: Re: No channels available (no IR) in 5Ghz band for intel 7260-ac
From: Victor <silentworks@gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-06-24 9:37 GMT+02:00 Emmanuel Grumbach <egrumbach@gmail.com>:
>
>
> On 06/24/2014 03:50 AM, Luis R. Rodriguez wrote:
>> On Mon, Jun 23, 2014 at 10:55:48PM +0200, Victor wrote:
>>> Hello, first of all i'm not sure if this is the proper place to ask
>>> since it seems mostly dev-related, but i have been looking everywhere
>>> trying to find a solution without luck, so i'm not sure if i
>>> encountered some kind of bug.
>>>
>>> Context: Setup of wireless AP using an intel 7260-ac on 5Ghz+ band, linux 3.15.1
>
> This configuration is not supported.

Do you know why? it is supported in other kernel version?, i got the
device mainly for to be used as 802.11ac AP  :/, on the product brief
they state it is designed for AP mode
http://www.intel.es/content/dam/www/public/us/en/documents/product-briefs/dual-band-wireless-ac-7260-bluetooth-brief.pdf,
and in iw it appears as supported too

Thanks.

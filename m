Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57680 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaFXMup (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 08:50:45 -0400
Received: by mail-lb0-f174.google.com with SMTP id u10so358545lbd.33
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 05:50:43 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 24 Jun 2014 15:50:43 +0300
Message-ID: <CANUX_P3+bvv_TBVAR2dto+pYAQWdx-49cVbG_1gY8Qun_=cD5Q@mail.gmail.com> (sfid-20140624_145103_426326_95562883)
Subject: Setup of wireless AP using an intel 7260-ac on 5Ghz+ band, linux
 3.15.1 (was: No channels available (no IR) in 5Ghz band for intel 7260-ac
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Victor <silentworks@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>
>>
>> On 06/24/2014 03:50 AM, Luis R. Rodriguez wrote:
>>> On Mon, Jun 23, 2014 at 10:55:48PM +0200, Victor wrote:
>>>> Hello, first of all i'm not sure if this is the proper place to ask
>>>> since it seems mostly dev-related, but i have been looking everywhere
>>>> trying to find a solution without luck, so i'm not sure if i
>>>> encountered some kind of bug.
>>>>
>>>> Context: Setup of wireless AP using an intel 7260-ac on 5Ghz+ band, linux 3.15.1
>>
>> This configuration is not supported.
>
> Do you know why? it is supported in other kernel version?, i got the
> device mainly for to be used as 802.11ac AP  :/, on the product brief
> they state it is designed for AP mode
> http://www.intel.es/content/dam/www/public/us/en/documents/product-briefs/dual-band-wireless-ac-7260-bluetooth-brief.pdf,
> and in iw it appears as supported too
>

AP mode is supported - not on 5.2 GHz band.

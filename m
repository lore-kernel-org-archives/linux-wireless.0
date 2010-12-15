Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:31691 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366Ab0LOPPD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 10:15:03 -0500
Received: from vaebh102.NOE.Nokia.com (vaebh102.europe.nokia.com [10.160.244.23])
	by mgw-sa01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oBFFF0A1006776
	for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 17:15:00 +0200
Message-ID: <4D08DBDC.5070908@nokia.com>
Date: Wed, 15 Dec 2010 17:16:44 +0200
From: Roger Quadros <roger.quadros@nokia.com>
MIME-Version: 1.0
To: Luciano Coelho <luciano.coelho@nokia.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] wl12xx_sdio_test: rename files to match current style
References: <1292423499-5667-1-git-send-email-luciano.coelho@nokia.com>	 <1292423633.32385.9.camel@chilepepper> <1292424501.32385.10.camel@chilepepper>
In-Reply-To: <1292424501.32385.10.camel@chilepepper>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/15/2010 04:48 PM, Luciano Coelho wrote:
> On Wed, 2010-12-15 at 16:33 +0200, ext Luciano Coelho wrote:
>> On Wed, 2010-12-15 at 16:31 +0200, luciano.coelho@nokia.com wrote:
>>> From: Luciano Coelho<luciano.coelho@nokia.com>
>>>
>>> Change some file names and Kconfig settings so that this new module matches
>>> the new way of using wl12xx instead of wl1271.
>>>
>>> Also fix SDIO power enabling and disabling to match the latest way of doing
>>> it.
>>>
>>> Cc: Roger Quadros<roger.quadros@nokia.com>
>>> Signed-off-by: Luciano Coelho<luciano.coelho@nokia.com>
>>> ---
>>
>> In v2 I used the -M flag (to detect renames, which I stupidly forgot
>> before) and removed the file names from the header of the sdio_test.c
>> file, since it's a bad idea to have it there (thanks Johannes for the
>> comments).
>
> Roger, I have just compile-tested this module in upstream.  Could you
> run at least some basic tests with it to make sure it works?
>
>

Luca,

I don't have a ready setup with me which boots mainline kernel and has wl1271 on 
sdio.

The only way to verify it is to load the module with the parameters rx=1 and 
tx=1 and see if the "testing started" message appears.

what platform do you use to verify with mainline kernel & sdio wl1271 ?

-- 
regards,
-roger

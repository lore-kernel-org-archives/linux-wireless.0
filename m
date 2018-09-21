Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:57652 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390281AbeIUVsj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 17:48:39 -0400
Subject: Re: Netgear R7800 - ath10k QCA 9984 firmware crash
To: Bruno Rosset <bruno.rosset@gmail.com>
References: <CAKMn2kT6+4iX72jLSnCrXWMJ+pBHrMpZtigqWjzFRLKWRoxrkA@mail.gmail.com>
 <1f79c9f7-86e5-b70a-9e0d-c021124a5d09@candelatech.com>
 <CAKMn2kQ4mZ=5egvOeL4PWUZbX0JbVyGdfuqQjevpVu=_cHqRGg@mail.gmail.com>
Cc: linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <d760b19a-2014-af1b-9a62-ee6031b23e39@candelatech.com> (sfid-20180921_175929_077650_2FD103CC)
Date: Fri, 21 Sep 2018 08:59:02 -0700
MIME-Version: 1.0
In-Reply-To: <CAKMn2kQ4mZ=5egvOeL4PWUZbX0JbVyGdfuqQjevpVu=_cHqRGg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 09/19/2018 01:56 PM, Bruno Rosset wrote:
> Hi,
>
> Done, thanks
> Le mer. 19 sept. 2018 à 22:45, Ben Greear <greearb@candelatech.com> a écrit :
>>
>> On 09/19/2018 01:37 PM, Bruno Rosset wrote:
>>> Hi all,
>>>
>>
>>> Various tests with others firmware from candelatech , stock LEDE 17.01
>>> or dd-wrt give me firmware crash also

The crash in my firmware decodes to something that looks probably like
the calibration data is wrong.

This is probably some issue with how the board data is selected, or maybe
the wrong board data is installed on the file system.

Thanks,
Ben

>>
>> Please open a bug for the candela firmware crash, I might be able to figure
>> out why it crashes:
>>
>> https://github.com/greearb/ath10k-ct/issues
>>
>> https://www.candelatech.com/ath10k-bugs.php
>>
>> Thanks,
>> Ben
>>
>>
>> --
>> Ben Greear <greearb@candelatech.com>
>> Candela Technologies Inc  http://www.candelatech.com
>>
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

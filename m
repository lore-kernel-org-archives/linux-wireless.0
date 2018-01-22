Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:12467 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751030AbeAVLcW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 06:32:22 -0500
Subject: Re: [PATCH v2 02/14] staging: wilc1000: removed unnecessary defined
 enums typedef
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <ganesh.krishna@microchip.com>
References: <1516616547-24654-1-git-send-email-ajay.kathat@microchip.com>
 <1516616547-24654-3-git-send-email-ajay.kathat@microchip.com>
 <90847f2f-449e-b34a-4a86-880e2b3670d7@microchip.com>
 <20180122112234.33sod7nfy7ps3pq4@mwanda>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <ebeb825e-5a92-7ea4-df8d-6bc40a5f804d@microchip.com> (sfid-20180122_123230_003029_C68508AB)
Date: Mon, 22 Jan 2018 13:32:19 +0200
MIME-Version: 1.0
In-Reply-To: <20180122112234.33sod7nfy7ps3pq4@mwanda>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 22.01.2018 13:22, Dan Carpenter wrote:
> On Mon, Jan 22, 2018 at 01:06:59PM +0200, Claudiu Beznea wrote:
>>
>>
>> On 22.01.2018 12:22, Ajay Singh wrote:
>>> Fix the "do not add new typedefs" issue found by checkpatch.pl
>>> script
>>>
>> >From https://www.kernel.org/doc/html/latest/process/submitting-patches.html#the-canonical-patch-format
>> the the message body line is wrapped at 75 columns.
>>
> 
> I normally consider 75 characters a maximum.  I wrap at 72 characters
> like a normal email.
> 
> If we get too hung up on procedures for their own sake then it makes
> sending patches a real pain.
I agree with you. This is not my intention even it may look this way with
my previous comments. Was just a note. My bad, next time I'll have to
specify this.

Thank you,
Claudiu Beznea  

There are some people I just don't send
> patches to because they are too much headache to deal with.> 
> regards,
> dan carpenter
> 
> 

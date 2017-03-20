Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:34029 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755816AbdCTSrm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 14:47:42 -0400
Received: by mail-ot0-f194.google.com with SMTP id x37so20241495ota.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Mar 2017 11:47:41 -0700 (PDT)
Subject: Re: [BUG] with a 4.10.x kernel it's impossible to apply country
 regulatory rules
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>
References: <09a819fc-c936-6838-654b-e349c58a09ec@gmail.com>
 <8c844f92-6148-2ad7-068c-a919891c7a90@lwfinger.net>
 <1489866302.13995.3.camel@sipsolutions.net>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <be488eab-b822-f99a-a0d2-737e52f5b048@lwfinger.net> (sfid-20170320_194745_281568_052936EF)
Date: Mon, 20 Mar 2017 13:47:39 -0500
MIME-Version: 1.0
In-Reply-To: <1489866302.13995.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/18/2017 02:45 PM, Johannes Berg wrote:
> On Sat, 2017-03-18 at 12:41 -0500, Larry Finger wrote:
>>
>> I have duplicated your bug and I have bisected it to
>>
>> commit 2ae0f17df1cd52aafd1ab0415ea1f1dd56dc0e2a
>> Author: Johannes Berg <johannes.berg@intel.com>
>> Date:   Mon Oct 24 14:40:04 2016 +0200
>>
>>      genetlink: use idr to track families
>>
>> This patch is quite extensive and I have no idea which part is
>> failing, thus all I can do is report this confirmation.
>
> I don't think that makes any sense - have you verified that reverting
> that makes it go away?

Something is wrong with my wireless-testing-next tree. I just built the mainline 
4.11-rc3, and it does not have the problem. I'm now sure that the bisection was 
wrong.

I will need to refresh w-d-n and try again.

Larry

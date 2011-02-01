Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:40508 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104Ab1BAEmG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 23:42:06 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 20:41:46 -0800
Message-ID: <4D478F12.1070404@atheros.com>
Date: Tue, 1 Feb 2011 10:11:54 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Fix memory leak due to failed PAPRD frames
References: <1296460529-13669-1-git-send-email-mshajakhan@atheros.com> <AANLkTimbtr8zKf6Nj0GmTccKU2u2ubTkL3a5BVSGfUK0@mail.gmail.com>
In-Reply-To: <AANLkTimbtr8zKf6Nj0GmTccKU2u2ubTkL3a5BVSGfUK0@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 01 February 2011 12:13 AM, Luis R. Rodriguez wrote:
> On Sun, Jan 30, 2011 at 11:55 PM, Mohammed Shafi Shajakhan
> <mshajakhan@atheros.com>  wrote:
>    
>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>
>> free the skb's when the Tx of PAPRD frames fails and also add a debug
>> message indicating that.
>>
>> Signed-off-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>      
> Is this a stable fix?
>    
No Luis, this problem came from some recent changes in PAPRD before that 
it was Ok.
>   Luis
>    

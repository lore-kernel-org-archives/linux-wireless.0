Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44010 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab1JLBwH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 21:52:07 -0400
Received: by gyb13 with SMTP id 13so198734gyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 18:52:06 -0700 (PDT)
Message-ID: <4E94F2C2.2040405@lwfinger.net> (sfid-20111012_035231_187683_1AEB494F)
Date: Tue, 11 Oct 2011 20:52:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>
Subject: Re: [PATCH 4/5] rtlwifi: rtl8192se: Updates from latest Realtek driver
 version - Part II
References: <1318005802-29057-1-git-send-email-Larry.Finger@lwfinger.net> <1318005802-29057-5-git-send-email-Larry.Finger@lwfinger.net> <20111011201615.GK6558@tuxdriver.com>
In-Reply-To: <20111011201615.GK6558@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/2011 03:16 PM, John W. Linville wrote:
> On Fri, Oct 07, 2011 at 11:43:21AM -0500, Larry Finger wrote:
>> From: Chaoming Li<chaoming_li@realsil.com.cn>
>>
>> This patch incorporate the differences between the 06/20/2011 and
>> 08/16/2011 Realtek releases of the rtl8192se driver.
>>
>> The changes include:
>>
>> 1. Fixing some typos in register usage.
>> 2. A change in the handling of decryption status for 802.11w packets.
>>
>> Signed-off-by: Chaoming Li<chaoming_li@realsil.com.cn>
>> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
>
> This patch doesn't apply (at least on wireless-next), and several of
> the others required fixups as well.  What tree did you base this upon?

I thought it was wireless-next, but with all the disruptions lately, I may have 
messed up. I'll check it out and send you a new one.

Larry


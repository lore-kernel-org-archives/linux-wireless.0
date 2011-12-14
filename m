Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:1124 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758212Ab1LNVwS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 16:52:18 -0500
Message-ID: <4EE91A87.5090207@canonical.com> (sfid-20111214_225222_119517_3F7C56F9)
Date: Wed, 14 Dec 2011 14:52:07 -0700
From: Tim Gardner <tim.gardner@canonical.com>
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: Re: Problems associating with RTL8188CE
References: <4ECA99CC.7020008@lwfinger.net> <20111121185610.GD6736@thinkpad-t410> <4ECB028E.3030809@lwfinger.net> <20111122022008.GA17661@thinkpad-t410> <20111213194231.GA30788@thinkpad-t410> <4EE7B85E.3070802@lwfinger.net> <20111213212606.GB30788@thinkpad-t410> <4EE82CC6.2030307@lwfinger.net> <20111214162333.GB19410@thinkpad-t410> <4EE8D150.8090100@lwfinger.net> <20111214164902.GD19410@thinkpad-t410>
In-Reply-To: <20111214164902.GD19410@thinkpad-t410>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/14/2011 09:49 AM, Seth Forshee wrote:
> On Wed, Dec 14, 2011 at 10:39:44AM -0600, Larry Finger wrote:
>> On 12/14/2011 10:23 AM, Seth Forshee wrote:
>>>
>>> I'm running 3.2-rc5 currently. The results are the same with
>>> bleeding-edge compat-wireless.
>>
>> I'm running 3.2-rc5 from wireless-testing, but I should test the one
>> from mainline. I'll also retest an RTL8188CE with my 802.11n AP.
>>
>> What model is that Cisco AP? Perhaps Realsil has one in their lab. I
>> do not have access to any Cisco hardware.
>
> It's a Linksys E2000.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I ordered a refurb Linksys E3000. Should be here Friday. My Lenovo x120e 
has the identical adapter. It seems to work pretty well except that it 
won't show up the WNDR3300 11N SSID in the list. I've tested thusly:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/902557/comments/52

rtg
-- 
Tim Gardner tim.gardner@canonical.com

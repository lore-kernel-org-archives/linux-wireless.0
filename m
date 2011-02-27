Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61202 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab1B0VwL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 16:52:11 -0500
Received: by iyb26 with SMTP id 26so2381917iyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Feb 2011 13:52:10 -0800 (PST)
Message-ID: <4D6AC785.6020502@lwfinger.net>
Date: Sun, 27 Feb 2011 15:52:05 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: Mathieu Malaterre <mathieu.malaterre@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Realtek RTL8192SE support ? (aka r8192se_pci)
References: <AANLkTinoU0Dxy2iAHEsprTbakrbs8a8vPARFW0odz4g9@mail.gmail.com> <4D628D75.1070907@lwfinger.net> <AANLkTi=RaQonkove9=BrRJFpf+Oc3qkq29sNkxvwRP7w@mail.gmail.com>
In-Reply-To: <AANLkTi=RaQonkove9=BrRJFpf+Oc3qkq29sNkxvwRP7w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/27/2011 03:42 PM, Gábor Stefanik wrote:
> On Mon, Feb 21, 2011 at 5:06 PM, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>> On 02/21/2011 03:35 AM, Mathieu Malaterre wrote:
>>>
>>> Dear all,
>>>
>>>    As far as I know driver for rtl8192su will be added to kernel
>>> 2.6.38. By any chance does anyone knows if rtl8192se will make it into
>>> this release ?
>>
>> As part of our collaborative effort, Realtek has sent me a mac80211-based
>> driver for the RTL8192SE. It will be submitted to the wireless mailing list
>> for review once the driver for the RTL8192CU is accepted. The earliest this
>> would happen is 2.6.39, but I think 2.6.40 is more realistic. I also have a
>> driver for the RTL8192DE that will follow the RTL8192SE.
>
> Is there any reason why you are holding back release of these drivers?
> You know, the general Linux practice is release-early-release-often...

I know. The main reason is that I have been criticized regarding the quality of 
these drivers, and I want to get them in as good as shape as possible.

In addition, the rtl8192se driver that is merged with wireless-testing fails 
when allocating PCI resources, and I have not had time to sort it out.

Larry

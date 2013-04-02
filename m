Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:44863 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762170Ab3DBVCY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Apr 2013 17:02:24 -0400
Received: by mail-vc0-f182.google.com with SMTP id ht11so943478vcb.27
        for <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2013 14:02:23 -0700 (PDT)
Message-ID: <515B475D.2090709@lwfinger.net> (sfid-20130402_230228_959342_80C51500)
Date: Tue, 02 Apr 2013 16:02:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Juan Carlos Garza Fernandez <juancarlosgarza@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Status of the RTL8712 staging driver
References: <CAMEN=G4gwKC5oTbJyDfU4QcnO+EAff+nGsj+++AH0ip4eVV3MA@mail.gmail.com> <201304021941.37133.chunkeey@googlemail.com>
In-Reply-To: <201304021941.37133.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/02/2013 12:41 PM, Christian Lamparter wrote:
> On Tuesday, April 02, 2013 02:51:19 PM Juan Carlos Garza Fernandez wrote:
>> Now I have another question regarding the 8712 driver which has been
>> in staging forever.
>>
>> In your opinion, are there any chances that it will be improved to
>> reach the mainline level?

Yes, r8712u has been in staging for a long time; however, it is not a matter of 
improving it. For a new wireless driver to be included in the main wireless 
directories, it must use mac80211. Making the change from the current softmac in 
r8712u to a mac80211-based driver is essentially a complete rewrite. As r8712u 
functions quite well in station mode, I have not felt inclined to rework it for 
AP mode, particularly when a user can obtain a functioning router/AP for about 
$30. I feel that my time is better spent converting the drivers for Realtek 
devices that are not currently in the kernel. That list includes the rtl8723ae 
driver in 3.8, the rtl8188ee driver that will be in 3.10, and 3 other drivers 
that I currently have on my todo list.

Larry


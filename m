Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:62857 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaIJNpv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:45:51 -0400
Received: by mail-oi0-f53.google.com with SMTP id x69so7108050oia.12
        for <linux-wireless@vger.kernel.org>; Wed, 10 Sep 2014 06:45:51 -0700 (PDT)
Message-ID: <5410560D.8030300@lwfinger.net> (sfid-20140910_154554_737256_11519DCE)
Date: Wed, 10 Sep 2014 08:45:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>,
	Bastien Nocera <hadess@hadess.net>
CC: Marcel Holtmann <marcel@holtmann.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Realtek GPIO chipset, for Baytrail?
References: <1410256608.4077.7.camel@hadess.net>	 <540F54B1.8040409@lwfinger.net> <1410292835.4077.21.camel@hadess.net>	 <540F61FE.2050404@lwfinger.net>	 <7234781D-5B78-404A-B945-D090938777C7@hadess.net>	 <D08A763F-AD50-449D-98C6-B82866F49480@holtmann.org>	 <54100FF7.5060904@broadcom.com> <1410342645.4077.28.camel@hadess.net> <54102635.2040403@broadcom.com>
In-Reply-To: <54102635.2040403@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/10/2014 05:21 AM, Arend van Spriel wrote:
> On 09/10/14 11:50, Bastien Nocera wrote:
>>
>> Indeed. That did the trick.
>>
>> mmc0:0001 is the builtin storage, mmc1:0001:1 however is an unbound
>> device with vendor 0x024c and device 0xb723 (modalias:
>> sdio:c07v024CdB723). More interestingly class is 0x07, which udev
>> interprets as "WLAN interface".
>
> Now you have to find and load the right driver.

In response to a question from me, my contact at Realtek sent me such a driver 
last night. I have forwarded it to Bastien and he should be in business soon.

Larry



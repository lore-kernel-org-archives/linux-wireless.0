Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:64081 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbZFTCMe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 22:12:34 -0400
Received: from [10.0.0.2] (ool-4573a3fb.dyn.optonline.net [69.115.163.251])
 by mta3.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KLI00DKLM4ZVKU0@mta3.srv.hcvlny.cv.net> for
 linux-wireless@vger.kernel.org; Fri, 19 Jun 2009 22:12:36 -0400 (EDT)
Date: Fri, 19 Jun 2009 22:12:35 -0400
From: Darren Blaber <dmbtech@gmail.com>
Subject: Re: iwl3945 not working after recent commits
In-reply-to: <43e72e890906191642kbcca090we1b03db19bf0e2c8@mail.gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Message-id: <4A3C4593.6050707@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
References: <4A3C2036.6060506@gmail.com>
 <43e72e890906191642kbcca090we1b03db19bf0e2c8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Fri, Jun 19, 2009 at 4:33 PM, Darren Blaber<dmbtech@gmail.com> wrote:
>   
>> Not sure which commit broke it, but using latest compat-wireless, I get
>> this:
>>
>>     
>
>   
>> Jun 17 19:17:11 pi kernel: [330532.746391] iwl3945 0000:0c:00.0: Failed to
>> register hw (error -17)
>>     
>
> Try now, I just updated the tarball with John's latest applied patches
> on wireless-testing.
>
> v2.6.30-26871-g25e4fbe
> wireless-testing latest tag:
> master-2009-06-19
> This is compat-release:
> master-2009-06-15-2-ged8e599
>
>   Luis
>   
Nope, I still receive
[168936.466609] iwl3945 0000:0c:00.0: Tunable channels: 11 802.11bg, 13 
802.11a channels
[168936.466613] iwl3945 0000:0c:00.0: Detected Intel Wireless WiFi Link 
3945ABG
[168936.466789] iwl3945 0000:0c:00.0: irq 28 for MSI/MSI-X
[168936.467229] iwl3945 0000:0c:00.0: Failed to register hw (error -17)
[168936.467366] iwl3945 0000:0c:00.0: PCI INT A disabled
[168936.467375] iwl3945: probe of 0000:0c:00.0 failed with error -17


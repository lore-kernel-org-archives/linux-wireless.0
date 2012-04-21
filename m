Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.multi.fi ([85.134.37.151]:59149 "EHLO smtp.multi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab2DUWVg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2012 18:21:36 -0400
Received: from tmb-laptop.supernet (55863541.cust.multi.fi [85.134.53.65] (may be forged))
	by smtp.multi.fi (8.14.4/8.14.4) with ESMTP id q3LMLWjV031920
	for <linux-wireless@vger.kernel.org>; Sun, 22 Apr 2012 01:21:34 +0300
Message-ID: <4F9332EE.3030106@mageia.org> (sfid-20120422_002139_361866_CDCD8D88)
Date: Sun, 22 Apr 2012 01:21:34 +0300
From: Thomas Backlund <tmb@mageia.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: Missing iwlwifi firmwares ?
References: <4F932A3D.2070701@mageia.org>  (sfid-20120421_235812_903118_31B5AB43) <1335045596.6516.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1335045596.6516.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

22.04.2012 00:59, Johannes Berg skrev:
> On Sun, 2012-04-22 at 00:44 +0300, Thomas Backlund wrote:
> 
>> When reviewing our firmware packages I noticed a few missing iwlwifi
>> firmwares according to kernel-3,3,1
> 
>> [...]
>> firmware:       iwlwifi-6000g2a-6.ucode
>> firmware:       iwlwifi-100-6.ucode
>> firmware:       iwlwifi-1000-6.ucode
>> [...]
>>
>> Theese three are missing from:
>> http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git;a=summary
>>
>> http://intellinuxwireless.org/?n=Downloads
>>
>>
>> The API 5 ucodes are awailable, but the driver expect API 6...
>>
>> So..., when will they be available ?
> 
> We don't really know, but it was really just due to a bug in the driver,
> it should use MODULE_FIRMWARE with the latest released rather than the
> latest testing version -- there's a patch in our queue to fix that.
> 
> johannes
> 

Any pointers to that patch ?

We are entering RC stage in less than 2 weeks.

--
Thoma

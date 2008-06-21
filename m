Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yergi.telenet-ops.be ([195.130.132.36]:54115 "EHLO
	yergi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbYFUPrU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2008 11:47:20 -0400
Received: from winston.telenet-ops.be (unknown [195.130.137.75])
	by yergi.telenet-ops.be (Postfix) with ESMTP id 3A6B05C8E98
	for <linux-wireless@vger.kernel.org>; Sat, 21 Jun 2008 17:47:28 +0200 (CEST)
Message-ID: <485D225A.8090604@telenet.be> (sfid-20080621_174749_972024_3A6CEC4F)
Date: Sat, 21 Jun 2008 17:46:34 +0200
From: Ian Schram <ischram@telenet.be>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: john@limongrafica.com, linux-wireless@vger.kernel.org
Subject: Re: building mac80211
References: <1214042097.12100.5.camel@Johnardbell> <200806211156.47246.mb@bu3sch.de>
In-Reply-To: <200806211156.47246.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Michael Buesch wrote:
> On Saturday 21 June 2008 11:54:57 John George Wright wrote:
>> Hi,
>>
>> I'm very new to the linux operating systems so please treat me as a
>> child.
>>
>> I have an Intel PRO/Wireless 3945ABG built into my laptop and I am
>> trying to adapt the latest version of ubuntu to work with it. I followed
>> some online instructions and downloaded the mac80211-10.0.4 tar,
>> unpacked it and used this command:
>>
>> make SHELL=/bin/bash
>>
>> but received the following error:
>>
>> Building modified version in 'modified/' directory:
>> Copying modified/ from origin/...done
>> Applying patches and scripts from pending/.
>>  + Applying: pending/0001-mac80211-Add-basic-IEEE-802.11n-support.patch
>> 	From 26e77a5fef845edcb5c27db52f413e7558db0e20 Mon Sep 17 00:00:00 2001
>> scripts/generate_modified: line 57: patch: command not found
>> -----patch failure output-----
>>
>> pending/0001-mac80211-Add-basic-IEEE-802.11n-support.patch failed.
>> Terminating.
>> If patch or script failed, check pre/ and post/ for current stage.
>> make: *** [modified] Error 1
>>
>> Would you have any idea where I'm going wrong?
> 
> apt-get install patch
> 

apt-getting patch will indeed solve that error, but will surely generate a different one a bit later in the
process.

If you have the latest version of ubuntu, you probably don't want to mess with the packages
at intellinuxwireless.org. as I understand it, they are deprecated for everything except older
kernels, from before iwlwifi was merged.

I think 8.04 ubuntu has a 2.6.24 kernel, so most likely it already has iwlwifi. You probaby want to
check that you have the firmware installed. in /lib/firmware.

if you really want the latest driver the compat wireless project is probably the way to go.
http://wireless.kernel.org/download/compat-wireless-2.6/

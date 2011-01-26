Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:58411 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624Ab1AZWxO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 17:53:14 -0500
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-36.nexicom.net [216.168.118.36])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p0QMrAtS021552
	for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 17:53:11 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id D53C1984A8
	for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 17:53:09 -0500 (EST)
Message-ID: <4D40A5D5.90000@lockie.ca>
Date: Wed, 26 Jan 2011 17:53:09 -0500
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
CC: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: no CONFIG_WIRELESS_EXT
References: <4D40774A.608@lockie.ca> <4D4090CD.9090407@hauke-m.de>
In-Reply-To: <4D4090CD.9090407@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/11 16:23, Hauke Mehrtens wrote:
> On 01/26/2011 08:34 PM, James wrote:
>> I installed compat-wireless-2011-01-25 and iwlist doesn't work but iw does.
>> The warning dmesg shows is "cfg80211: wext will not work because kernel
>> was compiled with CONFIG_WIRELESS_EXT=n. Tools using wext interface,
>> like iwconfig will not work." which is fine BUT my kernel is compiled with
>> CONFIG_WIRELESS=y
>> CONFIG_WIRELESS_EXT_SYSFS=y
>> and those are the only 2 'WIRELESS' anything.
>>
>> I have kernel 2.6.36.3.
> Hi,
>
> you have to activate CONFIG_WIRELESS_EXT and nothing else to use the
> wext interface. You can not doe this directly in your kernel config, you
> have to modify the KConfig or build something that depends on
> CONFIG_WIRELESS_EXT like ipw2200. Just set CONFIG_IPW200=m in the kernel
> configuration and it will also activate CONFIG_WIRELESS_EXT=y
Ah, I googled before but I never found that, thanks.
I will just try to use iw. :-)


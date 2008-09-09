Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([198.107.51.143]:4010 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbYIIMRx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 08:17:53 -0400
Message-ID: <48C6696F.7070004@canonical.com> (sfid-20080909_141758_275078_E115985D)
Date: Tue, 09 Sep 2008 06:17:51 -0600
From: Tim Gardner <tim.gardner@canonical.com>
MIME-Version: 1.0
To: Karol Szkudlarek <karol@mikronika.com.pl>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org
Subject: Re: kernel crash during suspend using iwl3945 driver 1.2.26k	on	ubuntu
 hardy
References: <48BC47C5.2070807@mikronika.com.pl>	 <1220425598.28282.190.camel@debian.sh.intel.com>	 <loom.20080903T181136-957@post.gmane.org> <1220601300.28282.291.camel@debian.sh.intel.com> <48C0EA41.5050103@mikronika.com.pl> <48C14AA2.1040202@lwfinger.net> <48C15A5E.6000301@canonical.com> <48C62D3C.8080907@mikronika.com.pl>
In-Reply-To: <48C62D3C.8080907@mikronika.com.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Karol Szkudlarek wrote:
> Tim Gardner pisze:
>> Larry Finger wrote:
>>> Karol Szkudlarek wrote:
>>>> Hello Zhu!
>>>>
>>>> It will be tough to see in 2.6.27-rc kernels beacuse I use Ubuntu 8.04
>>>> LTS
>>>> which uses 2.6.24 linux kernel. :-(
>>>>
>>> The Ubuntu team has a 2.6.27 kernel available. To quote the text of a
>>> message in a BCM4306 thread "1)  If you are comfortable installing
>>> packages on your own, the linux-image-2.6.27-* package is currently
>>> available for you to install and test."
>>>
>>> Larry
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-wireless" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> There is a Hardy package for the 2.6.27 kernel at
>>
>> http://ppa.launchpad.net/timg-tpi/ubuntu
>>
>> It is currently based on -rc5. I'll be updating it throughout the .27
>> development and stable cycle.
>>
>> rtg
> 
> I would like try 2.6.27 so today I checked
> http://ppa.launchpad.net/timg-tpi/ubuntu/dists/hardy/main/binary-i386/Packages
> 
> and I don't see any 2.6.27 packages...
> 
> Second question: do you precompiled also all modules? I need them to
> perform an upgrade and got the running system.
> 

I found I could not have 2 packages with the same name but different
versions in one PPA, so I moved the 2.6.27 package to the kernel team
PPA at:

http://ppa.launchpad.net/kernel-ppa/ubuntu

Sorry for the confusion.

rtg

-- 
Tim Gardner tim.gardner@canonical.com

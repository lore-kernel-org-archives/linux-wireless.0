Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([198.107.51.143]:3015 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbYIEQdX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2008 12:33:23 -0400
Message-ID: <48C15A5E.6000301@canonical.com> (sfid-20080905_183343_254494_23A4302E)
Date: Fri, 05 Sep 2008 10:12:14 -0600
From: Tim Gardner <tim.gardner@canonical.com>
MIME-Version: 1.0
To: Karol Szkudlarek <karol@mikronika.com.pl>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org
Subject: Re: kernel crash during suspend using iwl3945 driver 1.2.26k	on	ubuntu
 hardy
References: <48BC47C5.2070807@mikronika.com.pl>	 <1220425598.28282.190.camel@debian.sh.intel.com>	 <loom.20080903T181136-957@post.gmane.org> <1220601300.28282.291.camel@debian.sh.intel.com> <48C0EA41.5050103@mikronika.com.pl> <48C14AA2.1040202@lwfinger.net>
In-Reply-To: <48C14AA2.1040202@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> Karol Szkudlarek wrote:
>> Hello Zhu!
>>
>> It will be tough to see in 2.6.27-rc kernels beacuse I use Ubuntu 8.04
>> LTS
>> which uses 2.6.24 linux kernel. :-(
>>
> 
> The Ubuntu team has a 2.6.27 kernel available. To quote the text of a
> message in a BCM4306 thread "1)  If you are comfortable installing
> packages on your own, the linux-image-2.6.27-* package is currently
> available for you to install and test."
> 
> Larry
> -- 
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

There is a Hardy package for the 2.6.27 kernel at

http://ppa.launchpad.net/timg-tpi/ubuntu

It is currently based on -rc5. I'll be updating it throughout the .27
development and stable cycle.

rtg
-- 
Tim Gardner tim.gardner@canonical.com

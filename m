Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:47230 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbYKMKLe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 05:11:34 -0500
Message-ID: <491BF73B.4080403@linux.intel.com> (sfid-20081113_111138_704362_B09F9328)
Date: Thu, 13 Nov 2008 10:45:31 +0100
From: Marcel Holtmann <holtmann@linux.intel.com>
MIME-Version: 1.0
To: reinette chatre <reinette.chatre@intel.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Issue with ifconfig down and 4965 driver
References: <BCB72601-9DA2-4D89-BDF1-7B96254DA17C@linux.intel.com> <1226555293.1115.939.camel@rc-desk>
In-Reply-To: <1226555293.1115.939.camel@rc-desk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Reinette,

>> so I am running a 2.6.28-rc4 kernel and every time I stop  
>> wpa_supplicant or call ifconfig down on the 4965 card, I get a user  
>> noticeable delay (mouse freezes). Seems that some part inside the  
>> driver is actively sleeping with a busy-loop. This is really not an  
>> acceptable behavior since it is a day-to-day task to bring the device  
>> down. And for power concerns, we really wanna allow to bring down the  
>> interface.
>>
> 
> Please add your information to
> http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1790

all information are already in the Bugzilla. It is nothing fancy and 
easy to reproduce. Do we have a patch for it?

Regards

Marcel


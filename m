Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:45677 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbYJ3EOe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 00:14:34 -0400
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Message-Id: <3004345D-F3F9-4C05-AF12-196F31E9FCEB@linux.intel.com> (sfid-20081030_051436_410558_3F85284B)
From: Marcel Holtmann <holtmann@linux.intel.com>
To: reinette chatre <reinette.chatre@intel.com>
In-Reply-To: <1225321298.1115.309.camel@rc-desk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: Still 4965 issues with wireless-testing
Date: Thu, 30 Oct 2008 05:14:30 +0100
References: <5A6314C4-958B-43E7-B94D-FE5BABED89EA@linux.intel.com> <1225321298.1115.309.camel@rc-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Reinette,

>> so besides the point that the Ubuntu 8.10 kernel has a broken driver
>> for the Intel 4965 cards which will crash my X61 after less than one
>> minute uptime when it connects to my access point, I have my dmesg
>> full with warnings from the latest wireless-testing kernel.
>>
>> I know that we have discussed this before and Johannes' patch at  
>> least
>> turns it into warnings instead of killing my system completely, but I
>> am still surprised why this hasn't been fixed.
>>
>> Attached is one of the dmesg snippets. They occur multiple times per
>> minute.
>
> Could you please compare your testing with that done in
> http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1703 ?

so as usual I am running a 64-bit kernel and the AP is N-capable. I  
just connect to it with wpa_supplicant and after a few minutes these  
warnings keep showing and then they keep coming. The ucode is the  
latest downloaded from the website.

Regards

Marcel


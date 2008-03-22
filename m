Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail9.dslextreme.com ([66.51.199.94]:34189 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753518AbYCVDyP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2008 23:54:15 -0400
Message-ID: <47E482E0.6010905@gawab.com> (sfid-20080322_035420_353099_CBD7C643)
Date: Fri, 21 Mar 2008 20:54:08 -0700
From: Justin Madru <jdm64@gawab.com>
MIME-Version: 1.0
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: linux-wireless@vger.kernel.org, linux@vger.kernel.org
Subject: Re: [regression: 2.6.25-rc6: iwl3945]
References: <47E1953F.9020202@gawab.com> <D936D925018D154694D8A362EEB0892003F6F7A4@orsmsx416.amr.corp.intel.com>
In-Reply-To: <D936D925018D154694D8A362EEB0892003F6F7A4@orsmsx416.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chatre, Reinette wrote:
> On Wednesday, March 19, 2008 3:36 PM, Justin Madru  wrote:
>
>   
>> Mar 18 11:00:02 dell kernel: printk: 1 messages suppressed.
>> Mar 18 11:00:02 dell kernel: wlan0_rename: RX too short data
>> frame payload
>>     
>
> These messages are printed by the mac80211 stack when it receives little
> more than a 802.11 header ...
>  
>   
>> A 1-min Wireshark network dump (my address was 10.68.1.211):
>>    http://jdserver.homelinux.org/linux/wireshark-1min
>>     
>
> This capture does not show the 802.11 headers ... the frames start with
> their 802.3 (Ethernet) headers. Did you take this capture on the host
> self? If so, the capture will only show frames received by this host,
> but unfortunately the frames that cause the message to be displayed have
> already been dropped at this point. Is it possible to get a capture of
> everything that goes over the air? You will need a second wireless
> device that is in monitor mode in order to see this traffic. 
>
> Thanks!
>
> Reinette
>
>   

Yeah, I should have known that. I did take the capture from the kernel 
that didn't work. I'll try another capture on a kernel that doesn't give 
that message. And I'll set it to capture all packets over the air. It'll 
have to be on Monday or Tuesday when I'm at the Uni.

Justin

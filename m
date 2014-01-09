Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfr01.atomicdatacenters.com ([71.5.109.131]:48956 "EHLO
	mfr01.atomicdatacenters.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752543AbaAITgV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 14:36:21 -0500
Received: from localhost ([127.0.0.1] helo=mfr01.atomicdata.com)
	by mfr01.atomicdatacenters.com with esmtp (Exim 4.63)
	(envelope-from <steven@fndtn.com>)
	id 1W1LOu-0002qS-Kz
	for linux-wireless@vger.kernel.org; Thu, 09 Jan 2014 13:36:20 -0600
From: Steven Bateman <steven@fndtn.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: Issue with authentication to Aerohive APs
Date: Thu, 9 Jan 2014 19:36:19 +0000
Message-ID: <CEF45512.1681C%steven@fndtn.com> (sfid-20140109_203624_443828_3CFD6DB1)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For the client that I have in that thread, the info is the following:

Intel Centrino Advanced-N 6235
iwlwifi with iwlwifi-6000g2b-6 firmware
kernel is 3.11

The other user I'm working with I know the chipset is an Intel Centrino
Advanced-N 6200 with iwlwifi, but I don't know the firmware and kernel
version. I can request that info from the user if you deem it relevant.




Steve Bateman
Wireless Engineer
________________________________________

The FoundationGet Back To Work.
311 North 7th Avenue
Minneapolis, MN 55401
612.465.0700 Main
612.787.3202 Direct




612.338.9322 Faxhttp://www.fndtn.com <http://www.fndtn.com/>
Facebook <http://www.facebook.com/thefndtn> | Twitter
<http://twitter.com/thefndtn> | LinkedIn
<http://www.linkedin.com/companies/276539>









On 1/9/14 1:29 PM, "Larry Finger" <Larry.Finger@lwfinger.net> wrote:

>On 01/09/2014 01:13 PM, Steven Bateman wrote:
>> From: Steven Bateman <steven@fndtn.com>
>> Date: Thursday, January 9, 2014 11:34 AM
>> To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
>> "ilw@linux.intel.com"
>>   <ilw@linux.intel.com>
>> Subject: Issue with authentication to Aerohive APs
>>
>>
>>
>>
>> Hello,
>>
>>
>> I'm writing on behalf of about 4 or 5 users that are having issues
>> connecting to a WLAN that I manage. The majority of the information can
>>be
>> found at the following link, including relevant logs. I've enclosed the
>> packet capture
>>   from next to the station with failed authentications.
>>
>> 
>>http://community.aerohive.com/aerohive/topics/issue_with_linux_connectivi
>>ty
>> _in_a_high_density_wlan
>>
>> We seem to have narrowed it down to a possible driver or firmware bug,
>>but
>> I'm reliant on the user to provide me requested information. At the
>>moment
>> I'm requesting that the user upgrade or downgrade his firmware or
>>kernel in
>>   case that changes the behavior.
>>
>> I'd like to submit this to this group for review, and to see if you can
>> elucidate what might be happening so I that I can work towards a
>>solution
>> with these users.
>>
>
>For completeness, what device/driver pair(s) and kernel versions are the
>Linux 
>user(s) running?
>
>Larry
>


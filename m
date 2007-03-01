Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:33098 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932705AbXCALpF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2007 06:45:05 -0500
Message-ID: <45E6BCDF.7090602@yahoo.co.uk>
Date: Thu, 01 Mar 2007 12:45:35 +0100
From: Ivo Couckuyt <iv0co@yahoo.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, developers@islsm.org
Subject: Re: Patch: prism54usb, new device
References: <45E5A4C2.3090204@yahoo.co.uk> <1172748716.11911.34.camel@johannes.berg>
In-Reply-To: <1172748716.11911.34.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

i got the info from here:
http://bugs.gentoo.org/show_bug.cgi?id=142651
comments 17-19
19 suggested to sent it here

don't know about the actually driver name, it's known to me as islsm
which is not the same as the recently added p54? driver based on dscape 
(from wireless-dev)

regards,
ilm

Johannes Berg wrote:
> I guess this should be on the radar of the prism54 people since it
> applies against that driver and not p54?
>
> Please check the MAINTAINERS file (also on
> http://linuxwireless.org/en/developers/maintainers) next time.
>
> On Wed, 2007-02-28 at 16:50 +0100, Ivo Couckuyt wrote:
>   
>> Using islsm/prism54usb  succesfully with the Philips CPWUA054 device for 
>> a year now, made a little
>> patch for prism54usb
>> patched against
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
>>
>>
>> more info:
>> http://www.p4c.philips.com/cgi-bin/dcbint/cpindex.pl?ctn=CPWUA054/00&scy=BE&slg=NL&grp=PC_PRODUCTS_GR_BE_CONSUMER&cat=PC_NETWORKING_CA_BE_CONSUMER&sct=WIRELESS_ADAPTERS_SU_BE_CONSUMER
>>
>> regards,
>> ilm
>>     
>
>   

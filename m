Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:55597 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289AbaBSVBr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 16:01:47 -0500
Received: by mail-ee0-f47.google.com with SMTP id d49so468983eek.34
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 13:01:46 -0800 (PST)
Message-ID: <53051BB8.3040000@gmail.com> (sfid-20140219_220203_055893_D59AC8E8)
Date: Wed, 19 Feb 2014 23:01:44 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Thomas Backlund <tmb@mageia.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Intel Wireless 7260 AC firnware SW error
References: <52FFDC10.5020702@mageia.org> <CANUX_P26bMLiPjjor6q960VC9RxhCagS7Je8S7hpzte1R52swA@mail.gmail.com> <5304CDFB.2090202@mageia.org>
In-Reply-To: <5304CDFB.2090202@mageia.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/19/2014 05:30 PM, Thomas Backlund wrote:
> 
> 16.02.2014 08:29, Emmanuel Grumbach skrev:
> 
>> Can you please record tracing?
>>
>> trace-cmd record -e iwlwifi -e mac80211
>>
>> and try to reproduce?
>>
>> It may be a driver or a firmware issue, I can't really know with the
>> current data.
>> Thanks for reporting!
> 
> I can...
> 
> I assume this is the one you mean:
> http://git.kernel.org/cgit/linux/kernel/git/rostedt/trace-cmd.git
> 
> 

Exactly - but typically, distros have a package for that and it is good
enough. You should have to compile. Of course, you can get the code from
this git tree and compile it.

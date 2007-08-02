Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hu-out-0506.google.com ([72.14.214.233]:58798 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbXHBJRJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 05:17:09 -0400
Received: by hu-out-0506.google.com with SMTP id 19so306184hue
        for <linux-wireless@vger.kernel.org>; Thu, 02 Aug 2007 02:17:07 -0700 (PDT)
Message-ID: <46B1A0FF.4000504@gmail.com>
Date: Thu, 02 Aug 2007 11:16:47 +0200
From: dragoran <drago01@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: ipw3945-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	network manager <networkmanager-list@gnome.org>
Subject: Re: chaning mode only when interface down?
References: <46B18B77.5020802@gmail.com> <1186046044.24230.11.camel@johannes.berg>
In-Reply-To: <1186046044.24230.11.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2007-08-02 at 09:44 +0200, dragoran wrote:
>   
>> I noticed that I have to do ifdown wlan0 before I can change the mode 
>> with iwconfig.
>> When I do it while the interface is up I get a error that the device is 
>> busy.
>>     
>
> It is busy.
>
>   
ok
>> It seems to happen with ad-hoc, master and back from them to managed.
>> Is this a bug in the iwlwifi driver or in mac80211 ?
>>     
>
> Neither, it is expected behaviour.
ok thx for this info.
>  Blame it on Jean that wireless
> extensions are ill-defined and don't mandate this.
>
>   
>> Because of this NM can't create ad-hoc networks because it does it while 
>> the device is up.
>> Any ideas?
>>     
>
> Fix NM?
>
>   
Dan, something for you  ;)
does NM knows if the driver is a mac80211 one?


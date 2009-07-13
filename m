Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:37017 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbZGMHHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 03:07:54 -0400
Received: by wa-out-1112.google.com with SMTP id j5so387283wah.21
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2009 00:07:53 -0700 (PDT)
Message-ID: <4A5ADB52.3080401@gmail.com>
Date: Mon, 13 Jul 2009 02:59:30 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Tim Schneider <schneid5@cs.uni-bonn.de>
CC: Linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Reading the RSSI from a Kernel Module
References: <0D620DB9-0DF4-41BB-8686-5BC910F88C79@cs.uni-bonn.de>
In-Reply-To: <0D620DB9-0DF4-41BB-8686-5BC910F88C79@cs.uni-bonn.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tim Schneider wrote:
> Hi,
>
> I am trying to write a Kernel Module with an implementation of a new 
> TCP-Algorithm. Since I need to know the RSSI-Value (Received Signal 
> Strength indication) of the sent package, I extended the Pluggable 
> Congestion Control Mechanism by a new function which is called right 
> after the package is send. At that point, I need to read the RSSI-Value.
>
> I'm now trying to somehow access that value, but I can't figure out 
> how. I've come as far, that I found out about the Wirelless 
> Extensions, which seem to be very promising. In the header file the 
> author states, that this mechanism can be used by both user-space apps 
> and kernel modules. Unfortunately nobody seems to ever have used it in 
> kernel space, since I can't find any documentations about it. I've 
> already asked this question on the netdev mailing list. They told me, 
> that there is a new system  with a netlink based cfg80211/nl80211 
> interface in development right now , which is supposed to replace the 
> wireless extensions in the future. They also told me, that this would 
> probably be the correct mailing list for this kind of question.
>
I don't mean to make this a flame so please do not take it that way.  
How exactly do you expect to get the RECEIVED Signal Strength indication 
for a packet which you are SENDING? If you send it, you don't receive it...

Just my 0.02

-Rick Farina
> I would be very glad, if somebody could give me link to a page 
> containing informations about this topic, or even just a hint that 
> could help me.
>
> Thank you
>
> Tim Schneider
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


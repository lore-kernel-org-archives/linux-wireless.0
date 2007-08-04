Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hu-out-0506.google.com ([72.14.214.235]:51233 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbXHDJqr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Aug 2007 05:46:47 -0400
Received: by hu-out-0506.google.com with SMTP id 19so644005hue
        for <linux-wireless@vger.kernel.org>; Sat, 04 Aug 2007 02:46:44 -0700 (PDT)
Message-ID: <46B44AFF.70707@gmail.com>
Date: Sat, 04 Aug 2007 11:46:39 +0200
From: dragoran <drago01@gmail.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: Luis Correia <luis.f.correia@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-usb-devel@lists.sourceforge.net
Subject: Re: rt2500usb stopped working (vendor request error)
References: <46B1B0AE.7050205@gmail.com> <46B43415.1000808@gmail.com> <efe7343f0708040134v30b7ffc1mcfc9b61e555897c3@mail.gmail.com> <200708041146.37667.IvDoorn@gmail.com>
In-Reply-To: <200708041146.37667.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn wrote:
> On Saturday 04 August 2007, Luis Correia wrote:
>   
>> Well, it may be an hardware error you got on your stick.
>>     
>
> Nope, very doubtfully.
> When he is using the latest version there would be a big warning
> "Not an rt2500usb device" and the driver would halt loading after that.
>
>   
>> That or it is one of those wrongly named sticks which are actually
>> rt73... but i don't really know.
>>
>> One last test you could do, go to a friend that uses Windoze and see
>> if it works as a client and if yes, which driver did it detect, rt73
>> or rt2500usb.
>>     
>
> Hmm checking if at least it works on windows would be an idea,
> but I am really starting to suspect hardware problems...
>
>   
ok will test in on my fc6 server (where the last working driver still 
builds) and see if this one works.
if this does not work too I will test on windows to make sure thats a hw 
problem.

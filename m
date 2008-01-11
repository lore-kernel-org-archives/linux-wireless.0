Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:6856 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758617AbYAKNWj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 08:22:39 -0500
Received: by ug-out-1314.google.com with SMTP id z38so467510ugc.16
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jan 2008 05:22:38 -0800 (PST)
Message-ID: <47876C32.8090004@gmail.com> (sfid-20080111_132248_120281_004B4748)
Date: Fri, 11 Jan 2008 14:16:34 +0100
From: Ronald <ronald645@gmail.com>
Reply-To: ronald645@gmail.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Bcm4311 shuts down on closing lid (intended?)
References: <47866FE6.4010100@gmail.com>	 (sfid-20080110_192630_077617_B3331316) <1200052973.3861.167.camel@johannes.berg>
In-Reply-To: <1200052973.3861.167.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> The b43 driver in the linux kernel 2.6.24-rc7 works really good :) . 
>> Keep it up! However, one thing is bugging me: Why does the card stop 
>> sending/receiving packets when I close the lid? Is this behaviour 
>> intended in the new driver? If yes, can I disable it?
> 
> We had this before. You're wrong, the software isn't shut down. But the
> antenna in your laptop is in the screen so you're moving it from upright
> to horizontal which makes your signal strength drop enough to not work
> any more.
> 
> johannes
So that means the other drivers (bcm43xx and ndiswrapper) provided 
enough signal strength to keep the wireless going even when it was 
horizontal?

							Ronald

P.S. I want to add my wireless card to the list (of working cards) (it's 
not dell). How can I do this?

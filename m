Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:24806 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbYJaREu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 13:04:50 -0400
Received: by ug-out-1314.google.com with SMTP id 39so1300790ugf.37
        for <linux-wireless@vger.kernel.org>; Fri, 31 Oct 2008 10:04:48 -0700 (PDT)
Message-ID: <490B3AAC.1000803@gmail.com> (sfid-20081031_180455_599000_BC823645)
Date: Fri, 31 Oct 2008 13:04:44 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Pavel Roskin <proski@gnu.org>, Dave <kilroyd@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: Guidelines regarding separate directory
References: <4909EA78.3060700@lwfinger.net>	 (sfid-20081030_181107_189082_5740895D) <1225387309.3690.73.camel@johannes.berg>	 <490A17F3.5050802@gmail.com>  <1225399481.7931.5.camel@dv> <1225399682.3690.82.camel@johannes.berg>
In-Reply-To: <1225399682.3690.82.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>>> orinoco_pci.c
>>>       
>> orinoco_pci.c is a good candidate for removal.  It only supports the
>> hardware that is already supported by hostap_pci.
>>     
>
> Wait wait. I think everybody would rather see hostap go than orinoco
> since hostap is a huge complex thing and quite buggy.
>
>   
I really disagree with this statement.  Until kernel version 2.6.21 the 
hostap driver was used very widely by the wifi security community 
because of it's great abilities for monitor mode and frame injection.  
In kernel 2.6.21 there was a change that made the injection patches not 
work and my ability is insufficient to fix this regression, however, the 
orinoco driver has always had morbid issues with simple things such as 
monitor mode.

I understand that hostap needs some work, and it would be nice if 
someone volunteered to help fix the packet injection, but removing this 
driver in favor of orinoco_cs would be a serious regression.

thanks,
Rick Farina
> johannes
>   


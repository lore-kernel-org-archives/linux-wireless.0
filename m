Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:37872 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbZH1J1a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 05:27:30 -0400
Message-ID: <4A97A2EC.1080302@nokia.com>
Date: Fri, 28 Aug 2009 12:27:08 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: ext Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Oikarinen Juuso (Nokia-D-MSW/Tampere)" <juuso.oikarinen@nokia.com>,
	"Valo Kalle (Nokia-D/Tampere)" <Kalle.Valo@nokia.com>
Subject: Re: [PATCH 13/13] wl1271: added Juuso Oikarinen as module author
References: <1251406807-31495-1-git-send-email-luciano.coelho@nokia.com>	 <1251406807-31495-14-git-send-email-luciano.coelho@nokia.com>	 <1251408741.22482.14.camel@johannes.local>  <4A979D06.2000205@nokia.com> <1251450604.3456.1.camel@johannes.local>
In-Reply-To: <1251450604.3456.1.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext Johannes Berg wrote:
> On Fri, 2009-08-28 at 12:01 +0300, Luciano Coelho wrote:
>
>   
>> Is that the right way to do it? At least in include/linux/module.h it 
>> says this:
>>
>> /* Author, ideally of form NAME[, NAME]*[ and NAME] */
>> #define MODULE_AUTHOR(_author) MODULE_INFO(author, _author)
>>     
>
> Interesting, but I suspect that should just be changed.
>
> If you use multiple MODULE_AUTHOR, they will be shown as such:
>
> $ /sbin/modinfo ar9170usb | grep author
> author:         Christian Lamparter <chunkeey@web.de>
> author:         Johannes Berg <johannes@sipsolutions.net>
>
>
> If you use just one, it would be one long author: line with all of them.
> I think the multiple line case is much nicer.
>   

Yes, I totally agree with you.  I'll use multiple MODULE_AUTHOR()s.  ;)

-- 
Cheers,
Luca.


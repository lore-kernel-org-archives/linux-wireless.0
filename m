Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:34363 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbZH0VRs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 17:17:48 -0400
Message-ID: <4A96F7EF.6040101@nokia.com>
Date: Fri, 28 Aug 2009 00:17:35 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: "ext Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Oikarinen Juuso (Nokia-D-MSW/Tampere)" <juuso.oikarinen@nokia.com>,
	"Valo Kalle (Nokia-D/Tampere)" <Kalle.Valo@nokia.com>
Subject: Re: [PATCH 11/13] wl1271: use workqueue provided by mac80211 instead
 	of the default
References: <1251406807-31495-1-git-send-email-luciano.coelho@nokia.com> 	<1251406807-31495-12-git-send-email-luciano.coelho@nokia.com> <43e72e890908271402p2137ce3n4b7459f4ce5fba14@mail.gmail.com>
In-Reply-To: <43e72e890908271402p2137ce3n4b7459f4ce5fba14@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext Luis R. Rodriguez wrote:
> On Thu, Aug 27, 2009 at 2:00 PM, Luciano Coelho<luciano.coelho@nokia.com> wrote:
>   
>> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
>>
>> Use the workqueue provided by the mac80211 stack instead of the system
>> default queue.
>>     
>
> You mean ieee80211_queue_work() ? This patch seems to be based on an
> old wireless-testing.
>   

Oops! It seems like I have sent the wrong series of patches.  I'll have 
to review and resend tomorrow.

-- 
Cheers,
Luca.


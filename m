Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 30.mail-out.ovh.net ([213.186.62.213]:59331 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753603Ab0DIUiI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 16:38:08 -0400
Message-ID: <4BBF902B.7040504@free.fr>
Date: Fri, 09 Apr 2010 22:38:03 +0200
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Joerg Pommnitz <pommnitz@yahoo.com>, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] ath9k/mac80211 and 802.11n in IBSS mode
References: <382964.83589.qm@web51407.mail.re2.yahoo.com> <1270822655.3870.21.camel@jlt3.sipsolutions.net>
In-Reply-To: <1270822655.3870.21.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg a écrit :
> On Fri, 2010-04-09 at 03:03 -0700, Joerg Pommnitz wrote:
>   
>> Hello all,
>> the Atheros Windows drivers provide an option to enable 802.11n mode
>> for IBSS networks. I did not find any information in this regard for
>> mac80211 based drivers. So, is this supported and how would I enable
>> this feature? And, btw. what exactly would this mean?
>>     
>
> Benoit was working on this, but his last patchset missed the ability to
> actually configure this when requesting an IBSS join.
>
> johannes
>   
Exactly :-). I need to dig into iw source code and understand a bit of 
nl80211 before...
There was some problem with rate control as well that might be fixed by 
minstrel_ht as well.

Regards,
Benoit


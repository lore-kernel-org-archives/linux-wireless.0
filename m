Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:45017 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab3LDCKa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 21:10:30 -0500
Message-ID: <529E8F90.1020205@gmail.com> (sfid-20131204_031055_819388_B39CF8AE)
Date: Wed, 04 Dec 2013 10:12:32 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Joe Perches <joe@perches.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	rkuo <rkuo@codeaurora.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	David Miller <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: mac80211: tx.c: be sure of 'sdata->vif.type' must
 be NL80211_IFTYPE_AP when be in NL80211_IFTYPE_AP case
References: <528AEFB7.4060301@gmail.com>  <20131125011938.GB18921@codeaurora.org> <5292B845.3010404@gmail.com>  <5292B8A0.7020409@gmail.com> <5294255E.7040105@gmail.com>  <52957ADA.2080704@gmail.com>  (sfid-20131127_055211_558798_A7DF5684) <1385739487.8656.1.camel@jlt4.sipsolutions.net>  <5299D306.7070701@gmail.com>  (sfid-20131130_125901_519610_EDA4068E) <1385816013.4327.1.camel@jlt4.sipsolutions.net>  <5299ED38.4090509@gmail.com> <5299EFDD.6060405@gmail.com>  (sfid-20131130_150205_984535_068F14A9) <1385842134.6108.4.camel@jlt4.sipsolutions.net>  <1385843940.2664.4.camel@joe-AO722>  <1385890523.4171.1.camel@jlt4.sipsolutions.net>  <1385937499.2664.21.camel@joe-AO722> <1385995738.20277.4.camel@jlt4.sipsolutions.net>
In-Reply-To: <1385995738.20277.4.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=GB2312
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/02/2013 10:48 PM, Johannes Berg wrote:
> On Sun, 2013-12-01 at 14:38 -0800, Joe Perches wrote:
>> On Sun, 2013-12-01 at 10:35 +0100, Johannes Berg wrote:
>>> Good try, but no, now ap_sdata isn't even assigned. :)
>>
>> Right.  Oh well.  There's no improving this without
>> significant rewrite.  Even then, there may not be much
>> overall improvement.
> 
> I could see an improvement if we were to actually make changes to assign
> the pointer based on the iftype, when that changes, so that each
> function only has to handle the right type and we don't need the switch
> statement at all...
> 

OK, thanks, it is one of good ideas to me (which I can not find).  :-)


> But that's tricky to get right and I'm between vacations and holidays
> and all that ...
> 

It is really not urgent, and for keeping quality, it is necessary to
spend suitable time resource (e.g 1 hour or more) to  make, review and
test this kind of patch carefully by oneself.

So could you please help improve it when you have suitable related time
resources?


Thanks.
-- 
Chen Gang

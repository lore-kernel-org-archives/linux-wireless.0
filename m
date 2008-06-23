Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:41404 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbYFWHE2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 03:04:28 -0400
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Adrian Bunk" <bunk@stusta.de>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: RFC: always enable MAC80211_RC_PID?
References: <20080622125553.GB22539@cs181133002.pp.htv.fi>
	<43e72e890806220804i347b942claae7b725231afcce@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 23 Jun 2008 09:57:30 +0300
In-Reply-To: <43e72e890806220804i347b942claae7b725231afcce@mail.gmail.com> (ext Luis R. Rodriguez's message of "Sun\, 22 Jun 2008 20\:34\:10 +0530")
Message-ID: <87d4m88wpx.fsf@nokia.com> (sfid-20080623_090433_113737_EC4A290F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <mcgrof@gmail.com> writes:

> On Sun, Jun 22, 2008 at 6:25 PM, Adrian Bunk <bunk@stusta.de> wrote:
>> After the scheduled removal of MAC80211_RC_SIMPLE only
>> MAC80211_RC_DEFAULT_PID and MAC80211_RC_DEFAULT_NONE are
>> left as choices.
>>
>> Does MAC80211_RC_DEFAULT_NONE have any userbase serious enough to
>> justify all the constructs made for this case or could we simply
>> always enable MAC80211_RC_PID?
>
> You can currently only get away living without it if you are just
> using iwl3945 or iwl4965 as they provide their own rate control
> algorithms. In the future if other vendor drivers are added with their
> own rate control algorithm this list grows. Disabling PID will save
> you some space only on some embedded platforms. Although currently its
> not evident people would do this I do see this being a reasonable
> option to keep around for later.

I agree with Luis. There is a need for MAC80211_RC_DEFAULT_NONE,
please do not remove it.

-- 
Kalle Valo

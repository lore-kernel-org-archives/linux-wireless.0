Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:33956 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757750AbbCDPBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 10:01:39 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Marek Puzyniak <marek.puzyniak@tieto.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	<linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 3/4] mac80211: initialize rate control earlier for tdls station
References: <1424850911-21017-1-git-send-email-marek.puzyniak@tieto.com>
	<1424850911-21017-4-git-send-email-marek.puzyniak@tieto.com>
	<1425041427.1960.1.camel@sipsolutions.net>
Date: Wed, 4 Mar 2015 17:01:29 +0200
In-Reply-To: <1425041427.1960.1.camel@sipsolutions.net> (Johannes Berg's
	message of "Fri, 27 Feb 2015 13:50:27 +0100")
Message-ID: <878ufc7qnq.fsf@kamboji.qca.qualcomm.com> (sfid-20150304_160144_027411_B7D70FD3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> +Arik.
>
> It'd be nice (for me anyway) if you didn't send this in a series of
> other patches I don't care about - I only ever saw this due to
> patchwork.

Yes, mac80211 and driver patches need to be sent in separate series. I
will drop this series for now, please resend ath10k patches separetely.

AND please clearly document what mac80211 patches the ath10k patches
depend on.

-- 
Kalle Valo

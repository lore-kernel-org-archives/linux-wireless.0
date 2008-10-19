Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:53949 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYJSFln (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2008 01:41:43 -0400
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu Yi" <yi.zhu@intel.com>
Subject: Re: Power saving on mac80211
References: <43e72e890810171810t1c65642g998db601cfe2a390@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sun, 19 Oct 2008 08:41:08 +0300
In-Reply-To: <43e72e890810171810t1c65642g998db601cfe2a390@mail.gmail.com> (ext Luis R. Rodriguez's message of "Fri\, 17 Oct 2008 18\:10\:25 -0700")
Message-ID: <87bpxh6t1n.fsf@nokia.com> (sfid-20081019_074157_710805_3770EB2C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <mcgrof@gmail.com> writes:

> So I wanted to review power saving requirements for mac80211 and see
> who else out there is focusing on this now or *really soon* so we can
> divide and conquer on this. If you are interested please let us know
> so we can coordinate.

Nokia is very interested about client side PSM. Currently it's only
on/off type, but I would like to see a dynamic version of this there
the PSM will be enabled when the data path has been idle long enough
(eg. 200 ms). I will be sending patches later.

-- 
Kalle Valo

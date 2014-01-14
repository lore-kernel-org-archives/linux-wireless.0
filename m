Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:58389 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbaANI0U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 03:26:20 -0500
From: Kalle Valo <kvalo@adurom.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Pierre Bourdon <delroth@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Exporting the TSF to userland
References: <CA+V6dmh7Udn96GG0XGaabx-t6ZViu1RGk-xTawa_KbnCdro9Ew@mail.gmail.com>
	<1389007385.5891.9.camel@jlt4.sipsolutions.net>
	<CA+V6dmjoLx90vEwGZa8vRNHp0yWqKQnae+GcvEZHsCxR-oHnhg@mail.gmail.com>
	<87k3e3nk7f.fsf@purkki.adurom.net>
	<CANq1E4SrMVmEyLA1J9kQA565AZHBvB=5C7r0GSuhoK6UO5OVkQ@mail.gmail.com>
Date: Tue, 14 Jan 2014 10:26:18 +0200
In-Reply-To: <CANq1E4SrMVmEyLA1J9kQA565AZHBvB=5C7r0GSuhoK6UO5OVkQ@mail.gmail.com>
	(David Herrmann's message of "Tue, 14 Jan 2014 09:15:06 +0100")
Message-ID: <87d2jvnf4l.fsf@purkki.adurom.net> (sfid-20140114_092623_525170_21C6C4CD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Herrmann <dh.herrmann@gmail.com> writes:

>> Either nl80211 or debugfs. Maybe debugfs is better because this is more
>> or less a hack?
>
> It's supposed to be a real interface used to calculate timestamps for
> mpeg streams, iirc. So debugfs is no option here.

And how is sysfs any better? If you use sysfs right now I don't see why
debugfs would be any worse. You just need to check from your application
that it's mounted and find the location.

-- 
Kalle Valo

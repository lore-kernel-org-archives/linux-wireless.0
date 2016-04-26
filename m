Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45446 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbcDZLVd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 07:21:33 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Radu P <rrrpan@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinoud Koornstra <reinoudkoornstra@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Intel 7260 AC only using 802.11n not AC
References: <CAL3+40H6tHomoXqAL=m7F5OT4X8+qAm7RGsUyCMw1=U6ROyqhg@mail.gmail.com>
	<CAAA5faGpa9ePaZagPpNaXdXz8FZrsDr=M4pMGEVO6F3xUc+aZA@mail.gmail.com>
	<1461664802.16188.8.camel@sipsolutions.net>
	<CAL3+40ExBLbSqJekDndBZkAsNf0pp5rTCga+SSujnsP9To4U=A@mail.gmail.com>
	<874maozlrs.fsf@kamboji.qca.qualcomm.com>
	<CABPxzYKFgOPMTs_i7OXCrA40FrNzrRvAVmLk63P-mPmrQiYRkQ@mail.gmail.com>
Date: Tue, 26 Apr 2016 14:21:27 +0300
In-Reply-To: <CABPxzYKFgOPMTs_i7OXCrA40FrNzrRvAVmLk63P-mPmrQiYRkQ@mail.gmail.com>
	(Krishna Chaitanya's message of "Tue, 26 Apr 2016 16:34:30 +0530")
Message-ID: <87zisgy5s8.fsf@kamboji.qca.qualcomm.com> (sfid-20160426_132137_061921_5195E0E0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Krishna Chaitanya <chaitanya.mgit@gmail.com> writes:

> On Tue, Apr 26, 2016 at 4:20 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>> Radu P <rrrpan@gmail.com> writes:
>>
>> > iw list|grep -i VHT  <- still nothing
>>

[...]

> "iw phy " should give necessary info.

AFAICS "iw phy" and "iw list" are identical commands.

-- 
Kalle Valo

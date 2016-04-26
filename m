Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49201 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbcDZLkk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 07:40:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Radu P <rrrpan@gmail.com>
Cc: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
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
	<CAL3+40GYcS5Aou75mipFfikFYkUbsxmigpde7SdGPT=Mf1AjCA@mail.gmail.com>
Date: Tue, 26 Apr 2016 14:40:33 +0300
In-Reply-To: <CAL3+40GYcS5Aou75mipFfikFYkUbsxmigpde7SdGPT=Mf1AjCA@mail.gmail.com>
	(Radu P.'s message of "Tue, 26 Apr 2016 12:17:58 +0100")
Message-ID: <87vb34y4we.fsf@kamboji.qca.qualcomm.com> (sfid-20160426_134043_888048_055F6EB7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Radu P <rrrpan@gmail.com> writes:

> With the latest iw from the git repo I get:
>
>                 VHT Capabilities (0x038071a0):
>                         Max MPDU length: 3895
>                         Supported Channel Width: neither 160 nor 80+80
>                         short GI (80 MHz)
>                         TX STBC
>                         SU Beamformee
>                 VHT RX MCS set:
>                         1 streams: MCS 0-9
>                         2 streams: MCS 0-9
>                         3 streams: not supported
>                         4 streams: not supported
>                         5 streams: not supported
>                         6 streams: not supported
>                         7 streams: not supported
>                         8 streams: not supported
>                 VHT RX highest supported: 0 Mbps
>                 VHT TX MCS set:
>                         1 streams: MCS 0-9
>                         2 streams: MCS 0-9
>                         3 streams: not supported
>                         4 streams: not supported
>                         5 streams: not supported
>                         6 streams: not supported
>                         7 streams: not supported
>                         8 streams: not supported
>                 VHT TX highest supported: 0 Mbps
>
> Is it OK that it is reporting  "VHT TX highest supported: 0 Mbps" ?

Yeah, zero just means that the highest support rate is not defined. I
guess it's nicer if iw would print "Not defined" instead of "0 Mbps" but
nobody hasn't implemented that yet.

-- 
Kalle Valo

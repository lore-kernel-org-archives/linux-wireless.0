Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44056 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbcDZMDt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 08:03:49 -0400
Message-ID: <1461672224.16188.9.camel@sipsolutions.net> (sfid-20160426_140352_738288_D029AF3C)
Subject: Re: Intel 7260 AC only using 802.11n not AC
From: Johannes Berg <johannes@sipsolutions.net>
To: Radu P <rrrpan@gmail.com>, Kalle Valo <kvalo@codeaurora.org>
Cc: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	Reinoud Koornstra <reinoudkoornstra@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 26 Apr 2016 14:03:44 +0200
In-Reply-To: <CAL3+40GiJPvMJMOq3aJnpExh0NncSu+9RTSbWtMoAUb=cnFbjg@mail.gmail.com> (sfid-20160426_135420_045597_AEF1ED44)
References: <CAL3+40H6tHomoXqAL=m7F5OT4X8+qAm7RGsUyCMw1=U6ROyqhg@mail.gmail.com>
	 <CAAA5faGpa9ePaZagPpNaXdXz8FZrsDr=M4pMGEVO6F3xUc+aZA@mail.gmail.com>
	 <1461664802.16188.8.camel@sipsolutions.net>
	 <CAL3+40ExBLbSqJekDndBZkAsNf0pp5rTCga+SSujnsP9To4U=A@mail.gmail.com>
	 <874maozlrs.fsf@kamboji.qca.qualcomm.com>
	 <CABPxzYKFgOPMTs_i7OXCrA40FrNzrRvAVmLk63P-mPmrQiYRkQ@mail.gmail.com>
	 <CAL3+40GYcS5Aou75mipFfikFYkUbsxmigpde7SdGPT=Mf1AjCA@mail.gmail.com>
	 <87vb34y4we.fsf@kamboji.qca.qualcomm.com>
	 <CAL3+40GiJPvMJMOq3aJnpExh0NncSu+9RTSbWtMoAUb=cnFbjg@mail.gmail.com>
	 (sfid-20160426_135420_045597_AEF1ED44)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-04-26 at 12:54 +0100, Radu P wrote:
> Is there a way running
> 
> ./iw dev wlanX link
> 
> but to get the output for the 5 Ghz frequency?
> now I am getting only this:
> 
> freq: 2432
> tx bitrate: 130.0 MBit/s MCS 14 short GI

Sure: connect to a 5 GHz AP first :)

johannes

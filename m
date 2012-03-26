Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1797 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932740Ab2CZRPy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 13:15:54 -0400
Message-ID: <4F70A435.7050906@broadcom.com> (sfid-20120326_191557_692246_6354C061)
Date: Mon, 26 Mar 2012 19:15:33 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: =?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sgruszka@redhat.com" <sgruszka@redhat.com>,
	"jrnieder@gmail.com" <jrnieder@gmail.com>
Subject: Re: brcmsmac still woes, possible regression?
References: <CAKprTDELdRWtJWpmn9RMuMUYXxuaR6Cf41+jot4_fZixHQtcMw@mail.gmail.com>
 <4F6D939F.3030206@broadcom.com>
 <CAKprTDHSyh2Sv2wyY0hg4cjzWobV-zA4stY19-vB_hOBVAq5KQ@mail.gmail.com>
 <CAKprTDHpLtPu2+navGzJU9K8XX-h=Purw_q_Qs2mYn4QFEex+w@mail.gmail.com>
 <4F7035AD.1080503@broadcom.com> <20120326143232.GA17126@thinkpad-t410>
 <4F709F3E.1090405@broadcom.com> <20120326171301.GC17126@thinkpad-t410>
In-Reply-To: <20120326171301.GC17126@thinkpad-t410>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/26/2012 07:13 PM, Seth Forshee wrote:
> On Mon, Mar 26, 2012 at 06:54:22PM +0200, Arend van Spriel wrote:
>> I suspect the warning is caused because mac80211 flush callback is
>> done after scanning on channels 12 and/or 13. I have a quick fix.
>> The longer and preferred fix would be to cleanup channel.c and
>> incorporate your regdom change. I plan to do that in separate
>> patches.
>
> At this point I think the regdom patch I sent is incomplete. We can do a
> lot better. I'll follow up on the other thread a little later today with
> my thoughts.
>

Agree. And I will keep an eye on my email ;-)

Gr. AvS



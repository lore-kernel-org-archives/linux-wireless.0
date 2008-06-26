Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 25.mail-out.ovh.net ([91.121.27.228]:37273 "HELO
	25.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752380AbYFZWQx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 18:16:53 -0400
To: Tomas Winkler <tomasw@gmail.com>
Subject: Re: [PATCH 1/2] mac80211: add power management support
MIME-Version: 1.0
Date: Fri, 27 Jun 2008 00:10:06 +0200
From: <samuel@sortiz.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?Q?Miguel_Bot=C3=B3n?= <mboton.lkml@gmail.com>,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com
In-Reply-To: <1ba2fa240806261451n53e5cb8an70aad7b072121c2e@mail.gmail.com>
References: <200711161929.36283.mboton.lkml@gmail.com> <200711161953.26801.mboton.lkml@gmail.com> <20080626174058.GA3063@sortiz.org> <20080626175507.GA23142@tuxdriver.com> <1214504623.3783.22.camel@johannes.berg> <1ba2fa240806261451n53e5cb8an70aad7b072121c2e@mail.gmail.com>
Message-ID: <416e094b76d79fa1dd23afabd74ff78c@localhost> (sfid-20080627_001657_092665_AA4DB2A8)
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi Thomas=0D
=0D
On Fri, 27 Jun 2008 00:51:57 +0300, "Tomas Winkler" <tomasw@gmail.com>=0D
wrote:=0D
> On Thu, Jun 26, 2008 at 9:23 PM, Johannes Berg=0D
> <johannes@sipsolutions.net> wrote:=0D
>> On Thu, 2008-06-26 at 13:55 -0400, John W. Linville wrote:=0D
>>> On Thu, Jun 26, 2008 at 07:40:58PM +0200, Samuel Ortiz wrote:=0D
>>> > Hi John,=0D
>>> >=0D
>>> > On Fri, Nov 16, 2007 at 07:53:26PM +0100, Miguel Bot=C3=B3n wrote=
:=0D
>>> > > Ok, the previous patch had a little error.=0D
>>> > >=0D
>>> > > --=0D
>>> > >=0D
>>> > > This patch adds power management support in mac80211.=0D
>>> > Sorry for being late to the game, but would a similar patch again=
st=0D
> your=0D
>>> > -next-2.6 tree be considered for inclusion ?=0D
>>>=0D
>>> It seems like a reasonable start to me.  Anyone else have comments?=
=0D
>>=0D
>> I had one about it returning -EINVAL for all errors that was never=0D
>> addressed afaict.=0D
> =0D
> Didn't Yi submitted this one like year ago and rejected?=0D
I searched through the mailing list, but couldnt find anything else=0D
than this patch.=0D
=0D
=0D
> This is why we have currently implemented in iwlwif sysfs.=0D
> =0D
> /sys/class/net/wlanX/devices/power_level=0D
> there are defined 6 power levels=0D
> 0 - CAM mode (Continuous Aware Mode)=0D
> 6 - AUTO=0D
> 1 to 5 levels that specifies power save aggressiveness  empirically=0D
> developed.=0D
> AUTO - depends on system power source/level=0D
> system power level is AC or BATTERY  - currently we do not have=0D
> anything that tells us whether we run on battery or ac.=0D
> Other factor is association state.=0D
> =0D
> This can be expressed as=0D
> iwconfig power saving 1..5=0D
> iwconfig power off - > CAM mode=0D
> iwconfig power auto - this is unfortunately not defined by iwconfig=0D
> =0D
> If this acceptable we can submit the patch=0D
Are you talking about the wext patch, or the sysfs one ?=0D
I'd definitely be happy to have a look at the wext one.=0D
=0D
Cheers,=0D
Samuel.

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

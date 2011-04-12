Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10911 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1DLLaD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 07:30:03 -0400
From: Anantha Idapalapati <aidapalapati@nvidia.com>
To: Olof Johansson <olofj@chromium.org>,
	Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	Uday Raval <uraval@nvidia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Andy Ritger <ARitger@nvidia.com>,
	Rakesh Kumar <krakesh@nvidia.com>
Date: Tue, 12 Apr 2011 16:59:44 +0530
Subject: RE: [PATCH] CHROMIUM: config: bluetooth: rfkill driver
Message-ID: <108BD5B22FBF9E46BD793DEDBF92B7056CF1A55103@BGMAIL02.nvidia.com>
References: <1302532426-12846-1-git-send-email-aidapalapati@nvidia.com>
	<1302532734.6487.12.camel@jlt3.sipsolutions.net>
	<108BD5B22FBF9E46BD793DEDBF92B7056CF1A54FD2@BGMAIL02.nvidia.com>
	<1302533629.6487.14.camel@jlt3.sipsolutions.net>
 <BANLkTi=LT7u8d6dVDWkQ-xp-BZMYZgS_vQ@mail.gmail.com>
In-Reply-To: <BANLkTi=LT7u8d6dVDWkQ-xp-BZMYZgS_vQ@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Olof and all,

I made mistake while creating the patch after pushing the change to chromium review site. Now I send the correct file. Please review the latest patch I just send.

Thanks
Anantha

-----Original Message-----
From: olofj@google.com [mailto:olofj@google.com] On Behalf Of Olof Johansson
Sent: Monday, April 11, 2011 8:51 PM
To: Johannes Berg
Cc: Anantha Idapalapati; linville@tuxdriver.com; Uday Raval; linux-wireless@vger.kernel.org; Andy Ritger; Rakesh Kumar
Subject: Re: [PATCH] CHROMIUM: config: bluetooth: rfkill driver

[gah, this gmail account has html formatting on by default. repost in
plain text]

On Mon, Apr 11, 2011 at 7:53 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> On Mon, 2011-04-11 at 20:15 +0530, Anantha Idapalapati wrote:
> > Initially it was written specific to BCM4329. But because of the
> > reason most of the BT chips have similar switch on/off sequence, this
> > driver is made generic. If there is any specific changes required for
> > a particular platform, this driver can be taken as reference.
>
> Well, so, it still has bcm4329 all over the code, so you should get rid
> of that and just call it rfkill_gpio or something. Also, if it's all
> this generic, then how about you make an rfkill GPIO driver that works
> like the rfkill regulator driver we recently got?

Anantha,

This doesn't seem to be the same version of the driver as the last one
you uploaded to the Chromium OS code review system, which had all the
brcm4329 references renamed and moved out of the driver.

Any reason you wouldn't start out with the cleanest version before you submit?

The version I'm referring to is at:   http://codereview.chromium.org/6295009/


-Olof
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------

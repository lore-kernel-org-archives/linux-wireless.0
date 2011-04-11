Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5937 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab1DKPVU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 11:21:20 -0400
Received: from hpaq6.eem.corp.google.com (hpaq6.eem.corp.google.com [172.25.149.6])
	by smtp-out.google.com with ESMTP id p3BFLJc1013456
	for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2011 08:21:19 -0700
Received: from eye13 (eye13.prod.google.com [10.208.5.13])
	by hpaq6.eem.corp.google.com with ESMTP id p3BFLIFG030114
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2011 08:21:18 -0700
Received: by eye13 with SMTP id 13so1947756eye.3
        for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2011 08:21:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1302533629.6487.14.camel@jlt3.sipsolutions.net>
References: <1302532426-12846-1-git-send-email-aidapalapati@nvidia.com>
	<1302532734.6487.12.camel@jlt3.sipsolutions.net>
	<108BD5B22FBF9E46BD793DEDBF92B7056CF1A54FD2@BGMAIL02.nvidia.com>
	<1302533629.6487.14.camel@jlt3.sipsolutions.net>
Date: Mon, 11 Apr 2011 08:21:17 -0700
Message-ID: <BANLkTi=LT7u8d6dVDWkQ-xp-BZMYZgS_vQ@mail.gmail.com>
Subject: Re: [PATCH] CHROMIUM: config: bluetooth: rfkill driver
From: Olof Johansson <olofj@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Anantha Idapalapati <aidapalapati@nvidia.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Uday Raval <uraval@nvidia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Andy Ritger <ARitger@nvidia.com>,
	Rakesh Kumar <krakesh@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

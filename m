Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43555 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab3LCOZf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 09:25:35 -0500
Message-ID: <1386080727.4393.30.camel@jlt4.sipsolutions.net> (sfid-20131203_152538_768749_38F69351)
Subject: Re: [PATCH] cfg80211: fix WARN_ON for re-association to the expired
 BSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Ujjal Roy <royujjal@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Kernel <linux-wireless@vger.kernel.org>
Date: Tue, 03 Dec 2013 15:25:27 +0100
In-Reply-To: <CAE2MWkkA+5ki90wJ+vkSdeBiXygVv9vXhpGp0h+84+fbgbga0g@mail.gmail.com> (sfid-20131202_061920_049364_60F7EF5B)
References: <1385883096-7143-1-git-send-email-royujjal@gmail.com>
	 <1385890375.4171.0.camel@jlt4.sipsolutions.net>
	 <CAE2MWkkA+5ki90wJ+vkSdeBiXygVv9vXhpGp0h+84+fbgbga0g@mail.gmail.com>
	 (sfid-20131202_061920_049364_60F7EF5B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-12-02 at 10:49 +0530, Ujjal Roy wrote:
> So, can you please tell me what type of bugs or what bugs the cfg80211
> going to catch? As I see cfg80211 allows re-assoc command and the
> driver is able to get a BSS using the function cfg80211_get_bss(). So,
> the driver is going to re-associate and the result is a Kernel warning.
> At this point driver's internal association is successful though.

Yeah, I think you're right - I was confusing this with some Broadcom
thing (the joys of everyone using gmail ...)

Why would you ever reassoc to the exact same BSS? But anyway ... I'll
take a closer look at your patch/the code.

johannes


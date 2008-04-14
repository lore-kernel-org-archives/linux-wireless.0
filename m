Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbYDNTrd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2008 15:47:33 -0400
Subject: Re: Does mac80211 support ap mode
From: Dan Williams <dcbw@redhat.com>
To: cao jing <caojing.china@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <9f33c5230804141218j5778195ajc1a7bae011eb9528@mail.gmail.com>
References: <9f33c5230804141218j5778195ajc1a7bae011eb9528@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 15:44:40 -0400
Message-Id: <1208202280.12139.23.camel@localhost.localdomain> (sfid-20080414_204742_445593_54A5FE8E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-04-14 at 15:18 -0400, cao jing wrote:
> Hi,
> 
> I read the mac80211 code. I found only the STA, IBSS and Mesh_Point
> interface type are processed by the code. So does it support the ap
> mode.

Yes, it does.  I'd suggest using hostapd as your AP daemon and the
nl80211 hostap driver.  While it's still under pretty heavy development,
it all should be fairly usable.  Johannes Berg would probably have a
more up-to-date description of the status of the hostapd nl80211 driver
and mac80211 AP-mode support.

Dan



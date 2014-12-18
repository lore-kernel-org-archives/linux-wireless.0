Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out07.sjc.mx.trendmicro.com ([216.99.131.23]:52262 "EHLO
	out07.sjc.mx.trendmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751084AbaLRKqI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 05:46:08 -0500
Received: from relay10.sjc.mx.trendmicro.com (unknown [10.30.239.132])
	by out07.sjc.mx.trendmicro.com (Postfix) with ESMTP id 6BA009538E9
	for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 10:44:13 +0000 (UTC)
Received: from thinktube.com (unknown [111.68.225.247])
	by relay10.sjc.mx.trendmicro.com (Postfix) with ESMTP id 72DA798045B
	for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 10:46:06 +0000 (UTC)
Message-ID: <5492B068.40001@thinktube.com> (sfid-20141218_114612_502023_A2D6D78A)
Date: Thu, 18 Dec 2014 10:46:00 +0000
From: Bruno Randolf <br1@thinktube.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Dani Camps <danicamps81@gmail.com>, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: mac80211 USB adapters with 5GHz support and SMA antenna
References: <CAD3NH5X-neqP-61kP=C2oNPPJTQNBkarae0rh93Hm4qzdpZRew@mail.gmail.com> <54916C38.80103@thinktube.com> <5491819C.2050303@broadcom.com>
In-Reply-To: <5491819C.2050303@broadcom.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/17/2014 01:14 PM, Arend van Spriel wrote:
>> And what about the vendors which are more involved in proper linux
>> wireless develpment? Qualcom/Atheros, Intel, Broadcom: don't you have
>> any USB chipsets in line?
> 
> We do, but no mac80211-based USB devices.

Well, cfg80211 can be enough. Can you give us more information? Are
there any devices which are actually available? Which chipset would you
recommend?

In https://wikidevi.com/wiki/Broadcom the only chipset listed for USB
with "ac" which has more than "O devices" is BCM43526... It looks like
there is no driver for it and this chipset is not listed in
http://wireless.kernel.org/en/users/Drivers/brcm80211. Can we expect a
Linux driver for it anytime soon?

If we look at 2x2:2 abgn chipsets:
BCM4323	is not supported by brcmfmac
BCM43236 rev 3 seems to be supported (is rev 3 the same as BCM43236B?)

So, for BCM43236 rev 3, can we count with the following features:
- AP mode (how many STA?) with proper hostapd support?
- IBSS mode?

bruno

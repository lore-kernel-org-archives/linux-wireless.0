Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37345 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756996Ab2FYQNW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 12:13:22 -0400
Message-ID: <4FE88E1A.9050202@hauke-m.de> (sfid-20120625_181326_743363_A8910A57)
Date: Mon, 25 Jun 2012 18:13:14 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com
Subject: Re: Question about BCM43228 and outdated description in MAINTAINERS
References: <4FE886B3.7020202@lwfinger.net>
In-Reply-To: <4FE886B3.7020202@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/25/2012 05:41 PM, Larry Finger wrote:
> Hi,
> 
> I recently received a donated BCM43228 (14e4:4359) mini-PCIe card. At
> the moment, neither b43 nor brcmsmac support it. Although, grepping the
> proprietary driver wl shows that it would recognize that PCI ID, that
> driver does not load as it requires routine lockdep_init_map(), which is
> exported only for GPL modules. As a result, owners of this device can
> only use it with Linux if they can find a suitable Windows driver for
> use with ndiswrapper. In my experience, that means that 64-bit users are
> out of luck.
> 
> Reverse engineering this device to be able to drive it with b43 would
> involve a lot of effort. If your group is planning on adding it to
> brcmsmac, then I would not undertake this project. To the fullest extent
> that you can, please advise me regarding this matter.

The TODO list for brcmsmac at
http://linuxwireless.org/en/users/Drivers/brcm80211 contains the
following point since May 2011:

Add support for more chips, including (near term) BCM43227, BCM43228,
and BCM4331. Support for additional new chips to follow.

@Broadcom Are there any concrete, current plans for adding support for
these chips? Or would it be possible that you at least release the phy
code needed for these devices as is so that someone could integrate it
into brcmsmac or b43?

Hauke

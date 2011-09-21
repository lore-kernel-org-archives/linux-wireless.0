Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2643 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab1IUXPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 19:15:16 -0400
From: "Brett Rudley" <brudley@broadcom.com>
To: =?iso-8859-2?Q?Michael_B=FCsch?= <m@bues.ch>
cc: =?iso-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	"Greg KH" <greg@kroah.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 21 Sep 2011 16:15:10 -0700
Subject: RE: [PATCH 00/20] staging: brcm80211: 7th reaction for mainline
 patch #2
Message-ID: <7A94256FD72B884D9E7C55586C3CBCEE195814DE92@SJEXCHCCR01.corp.ad.broadcom.com> (sfid-20110922_011521_432410_47BA0CB6)
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
 <20110920130338.GA9885@kroah.com> <20110920132203.GB7800@tuxdriver.com>
 <20110920140020.GA11386@kroah.com>
 <7A94256FD72B884D9E7C55586C3CBCEE195814DD85@SJEXCHCCR01.corp.ad.broadcom.com>
 <CACna6rzSiH3g9y6F6t8JT4abCy0pO9v+ATCBeYmNdmNdo5BaDQ@mail.gmail.com>
 <7A94256FD72B884D9E7C55586C3CBCEE195814DE4F@SJEXCHCCR01.corp.ad.broadcom.com>
 <20110922003523.0bf6a460@milhouse>
In-Reply-To: <20110922003523.0bf6a460@milhouse>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> You guys obviously don't want to support legacy hardware. So there is
> absolutely
> no way to drop b43 in favor of brcmsmac. That is _impossible_.
> And I do agree that it would be completely insane for you guys to support
> the legacy
> b43 802.11g code.
> 
> The other way around, dropping brcmsmac in favor of b43 would be insanely
> stupid, too.
> It would basically be dropping broadcom-linux-wlan support. Nobody wants
> that.

Agree and we are not proposing that.

We did however initially propose (and implement) a dividing line of ssb chips for b43 and AXI based chips for brcmsmac but b43 team chose to ignore/reject that.  I haven't heard any counter-proposal from b43. We would love to hear one.

> I do, however, think that a separate broadcom-supported PHY module should
> be created,
> that is used by both brcmsmac and b43.

I'm not totally opposed to that idea but it does not solve the primary issue of conflicting b43 and brcmsmac modules.

Brett


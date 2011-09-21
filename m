Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:49909 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab1IUWfo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 18:35:44 -0400
Date: Thu, 22 Sep 2011 00:35:23 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: "Brett Rudley" <brudley@broadcom.com>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"Greg KH" <greg@kroah.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for mainline
 patch #2
Message-ID: <20110922003523.0bf6a460@milhouse> (sfid-20110922_003558_097592_9972A2E0)
In-Reply-To: <7A94256FD72B884D9E7C55586C3CBCEE195814DE4F@SJEXCHCCR01.corp.ad.broadcom.com>
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
	<20110920130338.GA9885@kroah.com>
	<20110920132203.GB7800@tuxdriver.com>
	<20110920140020.GA11386@kroah.com>
	<7A94256FD72B884D9E7C55586C3CBCEE195814DD85@SJEXCHCCR01.corp.ad.broadcom.com>
	<CACna6rzSiH3g9y6F6t8JT4abCy0pO9v+ATCBeYmNdmNdo5BaDQ@mail.gmail.com>
	<7A94256FD72B884D9E7C55586C3CBCEE195814DE4F@SJEXCHCCR01.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 21 Sep 2011 15:12:02 -0700
"Brett Rudley" <brudley@broadcom.com> wrote:

> But other than the one line comment on code, you still haven't answered the question of why you think b43 is a better driver.

I think that is a completely bogus question.
Whether b43 or brcmsmac is better does completely depend on the application.
And for that single reason I do not see either b43 or brcmsmac being dropped
in favor of the other one any time soon.

You guys obviously don't want to support legacy hardware. So there is absolutely
no way to drop b43 in favor of brcmsmac. That is _impossible_.
And I do agree that it would be completely insane for you guys to support the legacy
b43 802.11g code.

The other way around, dropping brcmsmac in favor of b43 would be insanely stupid, too.
It would basically be dropping broadcom-linux-wlan support. Nobody wants that.

I do, however, think that a separate broadcom-supported PHY module should be created,
that is used by both brcmsmac and b43.

-- 
Greetings, Michael.

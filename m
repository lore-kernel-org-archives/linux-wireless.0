Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1743 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab2A0Iqm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jan 2012 03:46:42 -0500
Message-ID: <4F22646E.1010507@broadcom.com> (sfid-20120127_094658_587498_ECB089F5)
Date: Fri, 27 Jan 2012 09:46:38 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Felix Fietkau" <nbd@openwrt.org>
cc: "Milan Bouchet-Valat" <nalimilan@club-internet.fr>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: BCM4313 keeps disconnecting with brcmsmac and multiple APs
References: <22905678.140637.1327401110095.JavaMail.www@wsfrf1232>
In-Reply-To: <22905678.140637.1327401110095.JavaMail.www@wsfrf1232>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/24/2012 11:31 AM, Milan Bouchet-Valat wrote:
> [  297.365453] wlan0: Wrong control channel in association response: configured center-freq: 2437 hti-cfreq: 2462  hti->control_chan: 11 band: 0.  Disabling HT.

Hi Felix,

My guess is that this message is coming from minstrel_ht. Could you
explain what it means?

Milan,

Does your AP have DFS enabled?

Gr. AvS


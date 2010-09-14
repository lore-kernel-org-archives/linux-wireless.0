Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37706 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab0INNE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 09:04:27 -0400
Subject: Re: Marshaling issues w/ compat-wireless-2010-08-19
From: Johannes Berg <johannes@sipsolutions.net>
To: Philip Prindeville <philipp_subx@redfish-solutions.com>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
In-Reply-To: <4C82CC10.7060903@redfish-solutions.com>
References: <4C746F74.70401@redfish-solutions.com>
	 <20100828171239.GA23885@jm.kir.nu> <4C79450C.80507@redfish-solutions.com>
	 <4C7C55E6.1060707@redfish-solutions.com>
	 <4C816E18.6050408@redfish-solutions.com>
	 <1283589824.3746.1.camel@jlt3.sipsolutions.net>
	 <4C82CC10.7060903@redfish-solutions.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 15:04:22 +0200
Message-ID: <1284469462.3704.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-09-04 at 15:45 -0700, Philip Prindeville wrote:

> >> bridge=br0
> >> driver=nl80211
> >> ssid=my-hp-test
> >> country_code=US
> >> hw_mode=g
> >> channel=10
> >> wep_default_key=0
> >> wep_key0=123456789a
> >> ieee80211n=1
> >>
> >> but what broke it was:
> >>
> >> wep_key_len_broadcast=5
> >> wep_key_len_unicast=5
> >> wep_rekey_period=300
> >>
> >> if I turned off those last 3, things work again.
> > Hah. I don't even know what that does. What were you trying to achieve?
> > Aren't those related to dynamic WEP, but you configured static WEP?

> I was trying to test the rekeying feature, where new keys are multicast when the group membership changes.

But then you need WEP with 802.1X, not statically configured keys.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38277 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbcAEQCh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 11:02:37 -0500
Message-ID: <1452009755.12357.44.camel@sipsolutions.net> (sfid-20160105_170241_005612_30E20363)
Subject: Re: Reading the current monitor flags of an interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Roger James <roger@beardandsandals.co.uk>,
	linux-wireless@vger.kernel.org
Date: Tue, 05 Jan 2016 17:02:35 +0100
In-Reply-To: <5687FA72.9000301@beardandsandals.co.uk> (sfid-20160102_173707_470075_5C473AA9)
References: <5687FA72.9000301@beardandsandals.co.uk>
	 (sfid-20160102_173707_470075_5C473AA9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-01-02 at 16:27 +0000, Roger James wrote:
> Hi,
> 
> I am trying to get at the current monitor flags setting of a wireless
> monitor mode virtual interface. I have tried to do this by hacking
> the 
> iw source. However I never see a NL80211_ATTR_MNTR_FLAGS attribute 
> returned in response to the
> 
> TOPLEVEL(info, NULL, NL80211_CMD_GET_INTERFACE, 0, CIB_NETDEV, 
> handle_interface_info,
>       "Show information for this interface.");
> 
> command in iw's interface.c code.
> 
> Questions.
> 
> 1. Am I wasting my time? (e.g. the rt2800usb driver never returns
> this 
> info, or there is another easy way of viewing this info, etc)
> 

Looks like it's never set in the corresponding kernel code.

johannes

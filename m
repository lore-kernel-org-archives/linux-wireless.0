Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:49302 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab1A0WJr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 17:09:47 -0500
Message-ID: <4D41ED24.9010005@hauke-m.de>
Date: Thu, 27 Jan 2011 23:09:40 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: James <bjlockie@lockie.ca>
CC: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: did compat-wireless-2011-01-27 crash dhcpcd?
References: <4D41DAF1.6080204@lockie.ca>
In-Reply-To: <4D41DAF1.6080204@lockie.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/27/2011 09:52 PM, James wrote:
> cfg80211: Calling CRDA to update world regulatory domain
> Compat-wireless backport release: compat-wireless-2011-01-06-3-g8db1608
> Backport based on linux-next.git next-20110121
> ath9k 0000:02:09.0: PCI INT A -> Link[LNKB] -> GSI 17 (level, low) -> IRQ 17
> ath: EEPROM regdomain: 0x10
> ath: EEPROM indicates we should expect a direct regpair map
> ath: Country alpha2 being used: CO
> ath: Regpair used: 0x10
> ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'


> cfg80211: wext will not work because kernel was compiled with
> CONFIG_WIRELESS_EXT=n. Tools using wext interface, like iwconfig will
> not work.

WEXT is deactivated in compat-wireless because CONFIG_WIRELESS_EXT=y was
not set in your kernel config and iwconfig does not work without wext.

See: http://www.spinics.net/lists/linux-wireless/msg63449.html

Hauke

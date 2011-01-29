Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:39209 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab1A2DB5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 22:01:57 -0500
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-36.nexicom.net [216.168.118.36])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p0T31rFx004223
	for <linux-wireless@vger.kernel.org>; Fri, 28 Jan 2011 22:01:54 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id E172F984A8
	for <linux-wireless@vger.kernel.org>; Fri, 28 Jan 2011 22:01:52 -0500 (EST)
Message-ID: <4D438320.1000800@lockie.ca>
Date: Fri, 28 Jan 2011 22:01:52 -0500
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
CC: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: did compat-wireless-2011-01-27 crash dhcpcd?
References: <4D41DAF1.6080204@lockie.ca>	<4D41ED24.9010005@hauke-m.de>	<4D41FDF7.3040805@lockie.ca> <AANLkTi=4rvKYSDiHNoM0YHMAd=nSmi=DELOp+9nxCwAM@mail.gmail.com>
In-Reply-To: <AANLkTi=4rvKYSDiHNoM0YHMAd=nSmi=DELOp+9nxCwAM@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/28/11 11:12, Brian Prodoehl wrote:
> On Thu, Jan 27, 2011 at 6:21 PM, James <bjlockie@lockie.ca> wrote:
>> On 01/27/11 17:09, Hauke Mehrtens wrote:
>>> On 01/27/2011 09:52 PM, James wrote:
>>>> cfg80211: Calling CRDA to update world regulatory domain
>>>> Compat-wireless backport release: compat-wireless-2011-01-06-3-g8db1608
>>>> Backport based on linux-next.git next-20110121
>>>> ath9k 0000:02:09.0: PCI INT A -> Link[LNKB] -> GSI 17 (level, low) -> IRQ 17
>>>> ath: EEPROM regdomain: 0x10
>>>> ath: EEPROM indicates we should expect a direct regpair map
>>>> ath: Country alpha2 being used: CO
>>>> ath: Regpair used: 0x10
>>>> ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
>>>> cfg80211: wext will not work because kernel was compiled with
>>>> CONFIG_WIRELESS_EXT=n. Tools using wext interface, like iwconfig will
>>>> not work.
>>> WEXT is deactivated in compat-wireless because CONFIG_WIRELESS_EXT=y was
>>> not set in your kernel config and iwconfig does not work without wext.
>>>
>>> See: http://www.spinics.net/lists/linux-wireless/msg63449.html
>>>
>>> Hauke
>>> --
>> I'm not using any tools.
>> The call trace happens after I do a modprobe.
>> I'm guessing it doesn't like dhcpcd.
>>
>> Do I really need CONFIG_WIRELESS_EXT?
> This still doesn't feel like the entire story.  Do you have
> NetworkManager running, by chance?
>
> -Brian
>
No Network Manager, I use Gentoo.
dhcpcd is running
I disabled wpa_suppliucant from auto starting.

Any ideas of what other processes to check for?

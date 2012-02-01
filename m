Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li235-22.members.linode.com ([173.255.225.22]:38474 "EHLO
	erley.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579Ab2BADTS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 22:19:18 -0500
Message-ID: <4F28AF35.9030800@erley.org> (sfid-20120201_041922_197198_09FB1DA2)
Date: Tue, 31 Jan 2012 22:19:17 -0500
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: Lars Duesing <lars.duesing@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Virtual Interfaces; using hostapd AND wpa_supplicant on the same
 physical device
References: <4F2670F4.3010706@gmail.com>
In-Reply-To: <4F2670F4.3010706@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/30/2012 05:29 AM, Lars Duesing wrote:
> Hi List,
>
> I'd like to create a temporary hotspot using an other wireless network which is already there.
> My kids have some devices (like Nintendo DS) which are only capable using WEP.
> So I want to create a temporary hotspot which I can filter on my own.
>
> Years ago I was able to do such a configuration, but this was before mac80211 (I was then often on trade fairs, with very costly wlan-tariffs...).
>
> Problem is: I get an error about a network name already exist - either on hostapd and wpa_supplicant - everytime the last program started.
>

You need to change the mac address of the second device once you create it.

Pat Erley

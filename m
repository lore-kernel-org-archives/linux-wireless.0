Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53831 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431Ab1JOMjt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Oct 2011 08:39:49 -0400
Message-ID: <4E997F13.7060602@openwrt.org> (sfid-20111015_144005_871960_99D3E335)
Date: Sat, 15 Oct 2011 14:39:47 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Stanislav Demakov <s.demakov@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Ath9k, single antenna on ar9280
References: <CAN=pzd+TcY+n90RBMU+Cpp0Bt9d_eAGgY4yffO+PSStWSzbf-Q@mail.gmail.com> <4E9970A6.10305@openwrt.org> <CAN=pzd+ou1DXL_d_W0dvTcYrNMfH9NjSoFUa=07fE4BYJ+N7bQ@mail.gmail.com> <4E997413.8010008@openwrt.org> <CAN=pzd+R42SArWR+gEgqvJ7h1_6ZnB61xyKzOo8FqNxkRhxqrQ@mail.gmail.com> <4E997A54.2080004@openwrt.org> <CAN=pzdLBxCB7U1+ig+ctPJKZMgC3D2V0KHOXXZH8ZVBgi67BQg@mail.gmail.com>
In-Reply-To: <CAN=pzdLBxCB7U1+ig+ctPJKZMgC3D2V0KHOXXZH8ZVBgi67BQg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-10-15 2:24 PM, Stanislav Demakov wrote:
> I'm running Ubuntu Server 11.10 - (kernel:  Linux server
> 3.0.0-12-generic x86_64)
>
> ath9k from compat-wireless-2011-10-12 and current iw from git compiled
> with libnl1.
>
> The wireless chip is AR9280. (2x2 MIMO)
>
> Also
> echo 1>  /sys/kernel/debug/ieee80211/phy0/ath9k/rx_chainmask
> echo 1>  /sys/kernel/debug/ieee80211/phy0/ath9k/tx_chainmask
> is written at boot.
>
> Is something wrong above?
Do not mess with the rx_chainmask/tx_chainmask parameters, that may be 
the reason why it's not working for you.

- Felix

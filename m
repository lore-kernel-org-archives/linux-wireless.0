Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52801 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334Ab1JOMTf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Oct 2011 08:19:35 -0400
Message-ID: <4E997A54.2080004@openwrt.org> (sfid-20111015_141943_539507_37550FA1)
Date: Sat, 15 Oct 2011 14:19:32 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Stanislav Demakov <s.demakov@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Ath9k, single antenna on ar9280
References: <CAN=pzd+TcY+n90RBMU+Cpp0Bt9d_eAGgY4yffO+PSStWSzbf-Q@mail.gmail.com> <4E9970A6.10305@openwrt.org> <CAN=pzd+ou1DXL_d_W0dvTcYrNMfH9NjSoFUa=07fE4BYJ+N7bQ@mail.gmail.com> <4E997413.8010008@openwrt.org> <CAN=pzd+R42SArWR+gEgqvJ7h1_6ZnB61xyKzOo8FqNxkRhxqrQ@mail.gmail.com>
In-Reply-To: <CAN=pzd+R42SArWR+gEgqvJ7h1_6ZnB61xyKzOo8FqNxkRhxqrQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-10-15 2:13 PM, Stanislav Demakov wrote:
> Ok, I've compiled and installed iw from git. Now I have this (wlan0 is down):
>
> sudo iw phy phy0 set antenna 1 1
>
> command failed: Operation not supported (-95)
No idea then. It works on all of my systems.

- Felix

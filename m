Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42432 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab1JOLwx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Oct 2011 07:52:53 -0400
Message-ID: <4E997413.8010008@openwrt.org> (sfid-20111015_135256_654119_CBC16953)
Date: Sat, 15 Oct 2011 13:52:51 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Stanislav Demakov <s.demakov@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Ath9k, single antenna on ar9280
References: <CAN=pzd+TcY+n90RBMU+Cpp0Bt9d_eAGgY4yffO+PSStWSzbf-Q@mail.gmail.com> <4E9970A6.10305@openwrt.org> <CAN=pzd+ou1DXL_d_W0dvTcYrNMfH9NjSoFUa=07fE4BYJ+N7bQ@mail.gmail.com>
In-Reply-To: <CAN=pzd+ou1DXL_d_W0dvTcYrNMfH9NjSoFUa=07fE4BYJ+N7bQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-10-15 1:45 PM, Stanislav Demakov wrote:
> Ok, just have tried:
>
> ifconfig wlan0 down
>
> and then tested it:
>
> iw phy phy0 set antenna all all
>
> but it's only showing iw help as before.
> I'm using the latest compiled compat-wireless.
Try using "1 1" instead of "all all".
Are you using the latest iw version?

- Felix

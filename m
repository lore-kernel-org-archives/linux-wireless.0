Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53339 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab1JOOWt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Oct 2011 10:22:49 -0400
Message-ID: <4E999737.50904@openwrt.org> (sfid-20111015_162258_719271_5AF291B9)
Date: Sat, 15 Oct 2011 16:22:47 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Stanislav Demakov <s.demakov@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Ath9k, single antenna on ar9280
References: <CAN=pzd+TcY+n90RBMU+Cpp0Bt9d_eAGgY4yffO+PSStWSzbf-Q@mail.gmail.com> <4E9970A6.10305@openwrt.org> <CAN=pzd+ou1DXL_d_W0dvTcYrNMfH9NjSoFUa=07fE4BYJ+N7bQ@mail.gmail.com> <4E997413.8010008@openwrt.org> <CAN=pzd+R42SArWR+gEgqvJ7h1_6ZnB61xyKzOo8FqNxkRhxqrQ@mail.gmail.com> <4E997A54.2080004@openwrt.org> <CAN=pzdLBxCB7U1+ig+ctPJKZMgC3D2V0KHOXXZH8ZVBgi67BQg@mail.gmail.com> <4E997F13.7060602@openwrt.org> <CAN=pzd+8b9cqc6BgvaF8vdq-CywJ7mNTVpeXz92ZvwJwefJOkA@mail.gmail.com> <CAN=pzdJgba-mdJHLDC+_LpgSiMwff4vbB-oUp2VDwYsSouedPA@mail.gmail.com>
In-Reply-To: <CAN=pzdJgba-mdJHLDC+_LpgSiMwff4vbB-oUp2VDwYsSouedPA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-10-15 3:41 PM, Stanislav Demakov wrote:
> And the last question...
> Can you confirm that after setting antenna configuration to 1x1 I can
> safely detach 2nd physical connector from the adapter? I mean is there
> a guarantees that device will only use the 1st antenna.
Changing the antenna configuration will alter the chainmask accordingly, 
so it should be safe to disconnect the second physical connector.

- Felix

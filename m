Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41710 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab1JOLiT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Oct 2011 07:38:19 -0400
Message-ID: <4E9970A6.10305@openwrt.org> (sfid-20111015_133822_226720_21EA9A92)
Date: Sat, 15 Oct 2011 13:38:14 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Stanislav Demakov <s.demakov@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Ath9k, single antenna on ar9280
References: <CAN=pzd+TcY+n90RBMU+Cpp0Bt9d_eAGgY4yffO+PSStWSzbf-Q@mail.gmail.com>
In-Reply-To: <CAN=pzd+TcY+n90RBMU+Cpp0Bt9d_eAGgY4yffO+PSStWSzbf-Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-10-14 5:46 PM, Stanislav Demakov wrote:
> I've noticed that set_antenna and get_antenna functionality was added
> to the ath9k driver. But iw phy set antenna command still isn't
> working.
Did you try bringing down all active wlanX interfaces belonging to that 
phy before running that command?

- Felix

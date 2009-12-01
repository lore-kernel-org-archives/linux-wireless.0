Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.216.174]:44451 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbZLATkM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 14:40:12 -0500
Received: by pxi4 with SMTP id 4so3751542pxi.4
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2009 11:40:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B0EE402.4040301@viagenie.ca>
References: <4B0C5E6F.5040302@viagenie.ca> <4B0C6493.7010805@erley.org>
	 <45e8e6c40911250735o334e23degdf0f1e421aa590b9@mail.gmail.com>
	 <4B0EE402.4040301@viagenie.ca>
Date: Tue, 1 Dec 2009 11:40:17 -0800
Message-ID: <45e8e6c40912011140j6c47104rb2784c0643dea869@mail.gmail.com>
Subject: Re: Hardware for 802.11s
From: Andrey Yurovsky <andrey@cozybit.com>
To: Simon Perreault <simon.perreault@viagenie.ca>
Cc: Pat Erley <pat-lkml@erley.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 26, 2009 at 12:24 PM, Simon Perreault
<simon.perreault@viagenie.ca> wrote:
> Andrey Yurovsky wrote, on 2009-11-25 10:35:
>> Can you please use a sniffer on the channel you
>> picked (it's channel 1 by default) and confirm that you see mesh
>> beacons from your devices once you "ifconfig up"?
>
> We just tried this and did not see *anything*.

Sorry for the late reply but I just tried a b43 card (PCMCIA in my
case, FW 410.2160, BCM4318) and mesh is working fine, and I do see
beacons when I "ifconfig up".  This is with today's wireless-testing.

  -Andrey

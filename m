Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f181.google.com ([209.85.128.181]:32996 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758132Ab3DEPYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 11:24:10 -0400
Received: by mail-ve0-f181.google.com with SMTP id pa12so3623334veb.26
        for <linux-wireless@vger.kernel.org>; Fri, 05 Apr 2013 08:24:10 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 5 Apr 2013 10:24:09 -0500
Message-ID: <CAJ8GFOjheLNiawD7K-VnGa5ishbnr6rm0YHUvJs8XgZK1EaJtQ@mail.gmail.com> (sfid-20130405_172414_661397_BD488D8F)
Subject: AR9342: Two odd packets in every beacon interval in 5Ghz
From: Harshal Chhaya <harshal@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

We have an AR9342-based AP that is sending out two odd packets each
beacon interval. These packets are 1804 bytes in size, are transmitted
at 6.5Mbps and have the dest MAC address the same as the source MAC
address.

The payload of these packets is all zeros.

It does this only in 5Ghz. These packets aren't transmitted in the 2.4Ghz band.

If we set the bandwidth to 40MHz, it sends only one of these packets
between beacons.

Are these some control or mgmt packets that are part of the protocol?
Or is this unexpected behavior?

The AP is running the 3.3.8 kernel and a compat-wireless from Sep 2012
(part of the openwrt image for this chip).

Thanks,
- Harshal

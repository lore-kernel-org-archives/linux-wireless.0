Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.nanl.de ([217.115.11.12]:56784 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946596Ab3BHQq4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 11:46:56 -0500
Received: from mail-ia0-f171.google.com (mail-ia0-f171.google.com [209.85.210.171])
	by mail.nanl.de (Postfix) with ESMTPSA id 8B53043D70
	for <linux-wireless@vger.kernel.org>; Fri,  8 Feb 2013 16:45:32 +0000 (UTC)
Received: by mail-ia0-f171.google.com with SMTP id z13so4432107iaz.2
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2013 08:46:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1302072238200.2736@pikachu.3ti.be>
References: <alpine.LRH.2.02.1302072238200.2736@pikachu.3ti.be>
From: Jonas Gorski <jogo@openwrt.org>
Date: Fri, 8 Feb 2013 17:46:27 +0100
Message-ID: <CAOiHx=kXAzMVwMoanZSeuiUQoyp_decgxPEvVUNyOnugGUZGFw@mail.gmail.com> (sfid-20130208_174700_130163_D38A1D17)
Subject: Re: BCM4321 (b43) on AppleTV (1st gen)
To: Dag Wieers <dag@wieers.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 February 2013 00:01, Dag Wieers <dag@wieers.com> wrote:
> Hi,
>
> For the OpenELEC project I am looking into getting better performance out of
> the b43 driver on the AppleTV (1st gen) device . The website reports the
> driver can do 802.11n (albeit on 2.4Ghz only), however using kernel 3.7.5
> (and earlier) I cannot get more than 3 MB/sec out of it (usually much less).

b43 currently cannot do 802.11n, it is limited 802.11g speed - it
certainly can use 802.11n capable cards, but it can only operate them
at 802.11g mode, and there 3 MB/sec seems quite good.

Regards
Jonas

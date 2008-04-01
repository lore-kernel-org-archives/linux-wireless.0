Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:55404 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757124AbYDASBq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 14:01:46 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Jgknn-0000Nt-ER
	for linux-wireless@vger.kernel.org; Tue, 01 Apr 2008 18:01:43 +0000
Received: from port-87-193-186-180.static.qsc.de ([87.193.186.180])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2008 18:01:43 +0000
Received: from thomas by port-87-193-186-180.static.qsc.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2008 18:01:43 +0000
To: linux-wireless@vger.kernel.org
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: RaLink RT2500 802.11g Cardbus/mini-PCI
Date: Tue, 01 Apr 2008 20:01:36 +0200
Message-ID: <fstta0$jhu$1@ger.gmane.org> (sfid-20080401_190212_110431_060D4A55)
References: <35856.201.36.161.238.1206999707.squirrel@mamao.cetuc.puc-rio.br> <200804010010.15705.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
In-Reply-To: <200804010010.15705.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn schrieb:
>> Is the last kernel code working with RaLink RT2500 802.11g Cardbus/mini-PCI?
> 
> With 'latest' do you mean:
>  latest 2.6.25-rc kernel?
>  latest wireless-testing git snapshot
>  latest rt2x00 git snapshot
> 
> The latter 2 should work fine, the first one has known issues
> but the state variates per person.

I was complaining about speed a while ago, so after reading this post, I 
thought I should try again and tell you:

The version in wireless-testing seems to work great, a test download 
gave me 1.24MB/s, which is about the same speed I get with my (Intel 
wireless) laptop. I am using rt2500pci.

Does the above mean that the stock driver in 2.6.25 will still be slow?


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33562 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634Ab1B1N3j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 08:29:39 -0500
Message-ID: <4D6BA33E.3070603@openwrt.org>
Date: Mon, 28 Feb 2011 14:29:34 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] p54: fix a NULL pointer dereference bug
References: <1298841562-62496-1-git-send-email-nbd@openwrt.org> <201102281308.27632.chunkeey@googlemail.com>
In-Reply-To: <201102281308.27632.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-02-28 1:08 PM, Christian Lamparter wrote:
> On Sunday 27 February 2011 22:19:22 Felix Fietkau wrote:
>> If the RSSI calibration table was not found or not parsed properly,
>> priv->rssi_db will be NULL, p54_rssi_find needs to be able to deal
>> with that.
> 
> Acked-by: Christian Lamparter <chunkeey@googlemail.com>
> 
> Did someone report an oops and if so, what card was it?
> And is it possible to get the EEPROM image?
Michael Buesch reported it using OpenWrt on the Nokia N810.
The image was generated with these tools:
http://nbd.name/gitweb.cgi?p=packages.git;a=tree;f=utils/calvaria/files/src;hb=HEAD

- Felix

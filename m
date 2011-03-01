Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41522 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955Ab1CARat (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 12:30:49 -0500
Received: by bwz15 with SMTP id 15so4790353bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 09:30:48 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH] p54: fix a NULL pointer dereference bug
Date: Tue, 1 Mar 2011 18:30:15 +0100
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Michael Buesch <mb@bu3sch.de>
References: <1298841562-62496-1-git-send-email-nbd@openwrt.org> <201102281308.27632.chunkeey@googlemail.com> <4D6BA33E.3070603@openwrt.org>
In-Reply-To: <4D6BA33E.3070603@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201103011830.15722.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 28 February 2011 14:29:34 Felix Fietkau wrote:
> On 2011-02-28 1:08 PM, Christian Lamparter wrote:
> > On Sunday 27 February 2011 22:19:22 Felix Fietkau wrote:
> >> If the RSSI calibration table was not found or not parsed properly,
> >> priv->rssi_db will be NULL, p54_rssi_find needs to be able to deal
> >> with that.
> > 
> > Acked-by: Christian Lamparter <chunkeey@googlemail.com>
> > 
> > Did someone report an oops and if so, what card was it?
> > And is it possible to get the EEPROM image?
> Michael Buesch reported it using OpenWrt on the Nokia N810.
Thanks. For a moment I feared that more broken devices are
out there.

> The image was generated with these tools:
> http://nbd.name/gitweb.cgi?p=packages.git;a=tree;f=utils/calvaria/files/src;hb=HEAD
you know, I have made some "tools" for editing & viewing
eeprom images as well:
http://git.kernel.org/?p=linux/kernel/git/chr/p54tools.git

Regards,
	Chr

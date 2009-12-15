Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:55035 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758143AbZLOCZU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 21:25:20 -0500
Received: by yxe17 with SMTP id 17so3252732yxe.33
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 18:25:18 -0800 (PST)
Message-ID: <4B26F38B.6080406@lwfinger.net>
Date: Mon, 14 Dec 2009 20:25:15 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ahmad Yasser <ahmad.xcoder@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Does the RTL8187 mac80211 drivers support master/ap mode?
References: <loom.20091215T030930-675@post.gmane.org>
In-Reply-To: <loom.20091215T030930-675@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/14/2009 08:10 PM, Ahmad Yasser wrote:
> Hi,
> I've been trying to use hostapd with my Wireless USB Dongle which has 
> an RTL8187L chipset, but it doesnt work at all, so I wanted to know, does
> the RTL8187 drivers support master/ap mode or is it not yet implemented?
> And if not yet, would they be implemented by 2.6.33?

It does not work in master/ap mode. It is on my list, but it will
certainly not be in 2.6.33, which is feature frozen. It may not even
make it for 2.6.34.

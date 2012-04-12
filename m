Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:35354 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964814Ab2DLOrU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 10:47:20 -0400
Received: by lahj13 with SMTP id j13so1621294lah.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2012 07:47:19 -0700 (PDT)
Message-ID: <4F86EAF4.7010102@gmail.com> (sfid-20120412_164724_268305_099F03B8)
Date: Thu, 12 Apr 2012 16:47:16 +0200
From: =?UTF-8?B?TWFydGluIEh1bmRlYsO4bGw=?= <m.hundeboll@gmail.com>
MIME-Version: 1.0
To: Dino Joseph Mycle <dinomycle@yahoo.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: wl12xx: receiving all packet(like Promiscuous mode)
References: <1334241114.15814.YahooMailNeo@web192304.mail.sg3.yahoo.com>
In-Reply-To: <1334241114.15814.YahooMailNeo@web192304.mail.sg3.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dino,

On 04/12/2012 04:31 PM, Dino Joseph Mycle wrote:
> When we configure it with CFG_RX_ALL_GOOD, that is 0x0x8 for the rx_config, the value is been set, but the effect is not there. Is there any dependency on the firmware ?

According to TI, the wl1271 firmware does not support monitor nor promisc mode:
http://e2e.ti.com/support/low_power_rf/f/307/t/139041.aspx

I had to switch to USB-sticks to get the promisc mode on my pandaboards.

// Martin

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:58001 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab0AaG6A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2010 01:58:00 -0500
Received: by pxi12 with SMTP id 12so3102221pxi.33
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jan 2010 22:57:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4dd58f491001271237o66bc7cd1p968a8894f324533d@mail.gmail.com>
References: <4dd58f491001270218t4eaac711xcb42658f8fbf375c@mail.gmail.com>
	 <17290.75428.qm@web24706.mail.ird.yahoo.com>
	 <4dd58f491001271237o66bc7cd1p968a8894f324533d@mail.gmail.com>
Date: Sat, 30 Jan 2010 22:57:59 -0800
Message-ID: <fd145f7d1001302257x658fb4eag948f542732c27a9d@mail.gmail.com>
Subject: Re: wlan/eth bridge stops working after a while: how to diagnose?
From: Jeffrey Baker <jwbaker@gmail.com>
To: Alexey Yudichev <ayudichev@gmail.com>
Cc: John Murdoch <weejoker@yahoo.com>, linux-wireless@vger.kernel.org,
	hostap@lists.shmoo.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 27, 2010 at 12:37 PM, Alexey Yudichev <ayudichev@gmail.com> wrote:
> Yes, I kept my symptoms simpler not to risk confusing more than one
> issue but indeed in many cases the client stops seeing the access
> point at all. Restarting hostapd fixes the network visibility but most
> likely does not fix the actual IP connectivity. Client keeps getting
> IP address correctly though so DHCP works.

Glad to hear I'm not the only one.  I have the _exact_ same problem on
a Debian/i486 system with ath9k radio and I have tried various
compat-wireless and hostapd trees without getting anywhere.

-jwb

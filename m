Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45146 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab1CQMRr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 08:17:47 -0400
Received: by fxm17 with SMTP id 17so2614942fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 05:17:46 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] rt2800usb stops working with big file transfers in AP and IBSS
Date: Thu, 17 Mar 2011 13:16:02 +0100
Cc: Juan Carlos Garza <juancarlosgarza@gmail.com>,
	linux-wireless@vger.kernel.org
References: <AANLkTik9wfkskAHEpmsm4_gPM0FFBf=q8OVXM99NBRjO@mail.gmail.com>
In-Reply-To: <AANLkTik9wfkskAHEpmsm4_gPM0FFBf=q8OVXM99NBRjO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103171316.02636.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 16. März 2011 schrieb Juan Carlos Garza:
> When configured as ad-hoc mode, it won't allow to turn off power
> savings (iwconfig wlan5 power off <-- fails)

AdHoc powersave is not supported and as such is never enabled.
 
> What else can I do? How can I get more debug information about what's happening?

Build rt2x00 with CONFIG_RT2X00_DEBUG and attach your kernel log here
after reproducing this issue please.

Helmut

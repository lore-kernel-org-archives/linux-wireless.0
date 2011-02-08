Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:48550 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341Ab1BHIs1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 03:48:27 -0500
To: Aleksandar Milivojevic <alex@milivojevic.org>
Cc: Johannes Stezenbach <js@sig21.net>, linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] [RFC] rt2x00: Add autowakeup timer for receiving beacons while in powersave mode
References: <201101311600.39486.IvDoorn@gmail.com>
	<874o8mbaec.fsf@purkki.adurom.net> <20110202212912.GA28687@sig21.net>
	<AANLkTinip3CZ8ZsY95E6dXnvhA_wEPSs4M7B+SmPY-ZM@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 08 Feb 2011 10:48:26 +0200
In-Reply-To: <AANLkTinip3CZ8ZsY95E6dXnvhA_wEPSs4M7B+SmPY-ZM@mail.gmail.com> (Aleksandar Milivojevic's message of "Mon\, 7 Feb 2011 15\:33\:19 -0800")
Message-ID: <87mxm69ajp.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Aleksandar Milivojevic <alex@milivojevic.org> writes:

> Half-related to above, and purely from user perspective.  Is there a
> way to disable power saving for WiFi cards globally by default (for
> example, by passing an option to device driver)?  Having power saving
> turned on by default makes sense for laptops, but doesn't make much
> sense for desktops.  And in my case (due to problem with at least some
> rt2xxx chips that Ivo described) it causes relatively frequent
> disconnects/reconnects from/to AP due to lost beacons.
>
> For my desktop system, I'd rather pass an option to device driver to
> have power saving default to off, and have a smoother network
> experience.

There is CONFIG_CFG80211_DEFAULT_PS kconfig option, but I'm not aware
of any other way to globally do this. I can only think of using iw or
iwconfig to disable power save per device.

-- 
Kalle Valo

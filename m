Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:59293 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753072Ab1F2PRe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 11:17:34 -0400
Message-ID: <4E0B4209.6040306@gmx.net> (sfid-20110629_171737_273868_0689F891)
Date: Wed, 29 Jun 2011 17:17:29 +0200
From: Alina Friedrichsen <x-alina@gmx.net>
MIME-Version: 1.0
To: =?UTF-8?B?RnLDqWTDqXJpYyBMYW1vcmNl?= <FLamorce@CalAmp.com>,
	linux-wireless@vger.kernel.org
Subject: Re: IPv6 "compatibility"
References: <1309272221-25787-1-git-send-email-mshajakhan@atheros.com> <8BFC9A1FBD4CFA4FA7496C9F6DBCF4CA0DC1B153ED@oxn-mx01.PD.CalAmpCorp.com>
In-Reply-To: <8BFC9A1FBD4CFA4FA7496C9F6DBCF4CA0DC1B153ED@oxn-mx01.PD.CalAmpCorp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Frédéric!

> Just to be sure, all the drivers/utilities (compat-wireless, iw, wpa_supplicant, hostpad, etc) are all completely independent from IPv6, right?

Yes, but if the driver doesn't support multicast correctly, IPv6 does 
not work, while IPv4 unicast works fine.

Cheers,
Alina


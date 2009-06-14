Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:55491 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbZFNPLt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Jun 2009 11:11:49 -0400
Subject: Re: [PATCH 0/2] ar9170: 1-stage firmware support / AVM fritz
From: Marcel Holtmann <marcel@holtmann.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, chunkeey@web.de,
	linux-wireless@vger.kernel.org, jal2@gmx.de,
	Peter.Grabienski@Atheros.com, Stephen.Chen@Atheros.com,
	Michael.Fortin@Atheros.com, Johnny.Cheng@Atheros.com,
	Yuan-Gu.Wei@atheros.com, otus-devel@lists.madwifi-project.org
In-Reply-To: <1243546565-19404-1-git-send-email-lrodriguez@atheros.com>
References: <1243546565-19404-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Date: Sun, 14 Jun 2009 17:11:48 +0200
Message-Id: <1244992308.15367.3.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

> This series now works for me on my WNDA31000, it took a newer shiny
> 1-stage firmware to work. I'll push the firmware into linux-firmware
> next.
> 
> Should work with the AVM Fritz devices now, haven't tested it but
> I think it should work.

I happened to have one of these AVM devices. With ar9170.fw firmware it
does work fine with the other ones it doesn't.

The ar9170.fw is still not in linux-firmware.git, any reason for that?

Also since ar9170-1.fw and ar9170-2.fw are not working at all, we better
not even try and give the user a crypted error message that the device
is in a bad state. Just printk that the firmware might be too old.

Regards

Marcel



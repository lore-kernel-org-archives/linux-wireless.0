Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3498 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbZEUPhR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 11:37:17 -0400
Date: Thu, 21 May 2009 11:36:56 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [WIP PATCH] sdio support for wl12xx
Message-ID: <20090521153656.GA19782@hash.localnet>
References: <20090518180957.GD2580@hash.localnet> <20090519040239.GA12911@hash.localnet> <877i0begt7.fsf@litku.valot.fi> <b6c5339f0905201223n4c8c4811h25a397e69a642c2a@mail.gmail.com> <87d4a2wli2.fsf@litku.valot.fi> <878wkqwl74.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <878wkqwl74.fsf@litku.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 21, 2009 at 06:05:19PM +0300, Kalle Valo wrote:
> Kalle Valo <kalle.valo@iki.fi> writes:
> > Not good. Can you somehow check if Google stores the NVS file to the
> > chip or somewhere else?
> 
> I'm guessing that the struct below is used for providing the NVS file
> from user space. Not sure, though.

Ah, indeed it does... initscript has:
service wlan_loader /system/bin/wlan_loader \
    -f /system/etc/wifi/Fw1251r1c.bin -e /proc/calibration \
    -i /system/etc/wifi/tiwlan.ini

wlan_loader source is in CUDK dir.

-- 
Bob Copeland %% www.bobcopeland.com


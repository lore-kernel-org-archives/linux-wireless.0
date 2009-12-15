Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 007.netroom.de ([194.0.247.207]:24490 "EHLO 007.netroom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849AbZLOMwH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 07:52:07 -0500
Message-ID: <4B278191.1010009@draisberghof.de>
Date: Tue, 15 Dec 2009 13:31:13 +0100
From: Josua Dietze <digidietze@draisberghof.de>
MIME-Version: 1.0
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
CC: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
	Stefan Seyfried <seife@sphairon.com>
Subject: Re: [PATCH] move eject code from zd1211rw to usb-storage
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com>
In-Reply-To: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefan Seyfried schrieb:

> The USB ID claimed by zd1211rw for the fake storage device is
> also in use by other, non-zd1211rw devices (Sphairon Homelink
> 1202). Move the eject of these devices to where it belongs and
> where all the needed infrastructure already exists: usb-storage.


We can do the eject (as other mode switches) in userspace. Previous 
discussions pointed into that direction.

And there is always the question of being able to access the "fake 
CD-ROM" without hacking the kernel.

I'd like to see these devices removed from unusual_devs.h.


Josua Dietze

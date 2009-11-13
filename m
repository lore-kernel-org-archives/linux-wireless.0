Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:51965 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbZKMFe0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 00:34:26 -0500
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL
From: Marcel Holtmann <marcel@holtmann.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, linux-input@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090911051259.GC23210@core.coreip.homeip.net>
References: <1252603292-20830-1-git-send-email-mjg@redhat.com>
	 <20090911051259.GC23210@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Nov 2009 06:34:26 +0100
Message-ID: <1258090466.3299.6.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Matthew,

> > Most laptops have keys that are intended to toggle all device state, not
> > just wifi. These are currently generally mapped to KEY_WLAN. As a result,
> > rfkill will only kill or enable wifi in response to the key press. This
> > confuses users and can make it difficult for them to enable bluetooth
> > and wwan devices.
> > 
> > This patch adds a new keycode, KEY_RFKILL_ALL. It indicates that the
> 
> The new name in description does not match the code...
> 
> > system should toggle the state of all rfkillable devices.
> 
> Hmm, rfkill changes usually go through net tree so unless they want me
> to push it though I'll just ACK the new keycode.
> 
> > 
> > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> Acked-by: Dmitry Torokhov <dtor@mail.ru>

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel



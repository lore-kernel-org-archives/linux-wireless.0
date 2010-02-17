Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:40607 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab0BQTmr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 14:42:47 -0500
MIME-Version: 1.0
In-Reply-To: <20100217191708.GA15554@core.coreip.homeip.net>
References: <1266356185-10324-1-git-send-email-mjg@redhat.com>
	 <20100217052247.GD7160@core.coreip.homeip.net>
	 <20100217180342.GA22522@srcf.ucam.org>
	 <22ee4e771002171043u2aaf97vd73c1090c2fce901@mail.gmail.com>
	 <20100217191708.GA15554@core.coreip.homeip.net>
Date: Wed, 17 Feb 2010 20:42:45 +0100
Message-ID: <22ee4e771002171142q1496842ap4079026a5c0be8c6@mail.gmail.com>
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL
From: Christian Lamparter <chunkeey@googlemail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, linux-input@vger.kernel.org,
	marcel@holtmann.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 17, 2010 at 8:17 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Wed, Feb 17, 2010 at 07:43:56PM +0100, Christian Lamparter wrote:
>> The reason: Some new devices come with a WPS "Push Button".
>> And there's no code for them yet.
>>
> Yes, we can add a new key definition if you provide clear description of
> what the intended use is and if we can't map such use to any existing
> key definitions.

I found one http://en.wikipedia.org/wiki/Wi-Fi_Protected_Setup (if you
don't mind):

There's the relevant part: (PBC stands for Push Button Control/Configuration?)

"PBC Method, in which the user simply has to push a button, either an actual
or virtual one, on both the AP (or a Registrar of the Network) and the new
wireless client device (STA)
.
Support of this model is mandatory for APs and optional for STAs."

And there are already a few potential users:
OpenWRT routers as well as some rt30xx, ar9170 and ar9271 devices.

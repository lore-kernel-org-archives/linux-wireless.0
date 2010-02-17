Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f200.google.com ([209.85.221.200]:63569 "EHLO
	mail-qy0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab0BQTyn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 14:54:43 -0500
Date: Wed, 17 Feb 2010 11:54:35 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, linux-input@vger.kernel.org,
	marcel@holtmann.org
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL
Message-ID: <20100217195435.GA15742@core.coreip.homeip.net>
References: <1266356185-10324-1-git-send-email-mjg@redhat.com>
 <20100217052247.GD7160@core.coreip.homeip.net>
 <20100217180342.GA22522@srcf.ucam.org>
 <22ee4e771002171043u2aaf97vd73c1090c2fce901@mail.gmail.com>
 <20100217191708.GA15554@core.coreip.homeip.net>
 <22ee4e771002171142q1496842ap4079026a5c0be8c6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <22ee4e771002171142q1496842ap4079026a5c0be8c6@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 17, 2010 at 08:42:45PM +0100, Christian Lamparter wrote:
> On Wed, Feb 17, 2010 at 8:17 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Wed, Feb 17, 2010 at 07:43:56PM +0100, Christian Lamparter wrote:
> >> The reason: Some new devices come with a WPS "Push Button".
> >> And there's no code for them yet.
> >>
> > Yes, we can add a new key definition if you provide clear description of
> > what the intended use is and if we can't map such use to any existing
> > key definitions.
> 
> I found one http://en.wikipedia.org/wiki/Wi-Fi_Protected_Setup (if you
> don't mind):
> 
> There's the relevant part: (PBC stands for Push Button Control/Configuration?)
> 
> "PBC Method, in which the user simply has to push a button, either an actual
> or virtual one, on both the AP (or a Registrar of the Network) and the new
> wireless client device (STA)
> .
> Support of this model is mandatory for APs and optional for STAs."
> 
> And there are already a few potential users:
> OpenWRT routers as well as some rt30xx, ar9170 and ar9271 devices.

Is there anything currently in works that would make use of this button?
I do not want to allocate keycode "for the future" which may never come.
We did it with KEY_BATTERY but I do not think anyone actually uses it.

-- 
Dmitry

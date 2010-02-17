Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f200.google.com ([209.85.221.200]:48328 "EHLO
	mail-qy0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab0BQTSZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 14:18:25 -0500
MIME-Version: 1.0
In-Reply-To: <20100217184502.GA23573@srcf.ucam.org>
References: <1266356185-10324-1-git-send-email-mjg@redhat.com>
	 <20100217052247.GD7160@core.coreip.homeip.net>
	 <20100217180342.GA22522@srcf.ucam.org>
	 <22ee4e771002171043u2aaf97vd73c1090c2fce901@mail.gmail.com>
	 <20100217184502.GA23573@srcf.ucam.org>
Date: Wed, 17 Feb 2010 20:18:23 +0100
Message-ID: <22ee4e771002171118h2a3c6494tb9cc70359536e179@mail.gmail.com>
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL
From: Christian Lamparter <chunkeey@googlemail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	linux-input@vger.kernel.org, marcel@holtmann.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 17, 2010 at 7:45 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Feb 17, 2010 at 07:43:56PM +0100, Christian Lamparter wrote:
>
>> Wait wait... do you can get another KEY_?
>>
>> The reason: Some new devices come with a WPS "Push Button".
>> And there's no code for them yet.
>
> What's a WPS button?

The Idea of this button is to "hook up" to WPS network with a
simple push of two buttons.
(One on the AP, another one at the STA).

That's right: no SSID and no keys.

> There's no fundamental issue with getting new KEY_
> codes defined, but bear in mind that anything greater than 255 won't be
> seen by X at present.
it would be great to get the "Push" event to Network Manager/
or any other wpa_supplicant GUI du jour one day.

In the mean time, it would help to have a common scan-code
ready.

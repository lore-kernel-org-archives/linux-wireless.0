Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45908 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab1FDQkV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2011 12:40:21 -0400
Date: Sun, 5 Jun 2011 01:40:22 +0900
From: Mattia Dongili <malattia@linux.it>
To: Marco Chiappero <marco@absence.it>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	platform-driver-x86@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 12/25] sony-laptop: input core improvements improvements
Message-ID: <20110604164021.GA12552@kamineko.org> (sfid-20110604_184047_393314_C64352D4)
References: <4DE8FC4A.9010401@absence.it>
 <4DE9012E.5040207@absence.it>
 <20110604080717.GC7194@kamineko.org>
 <4DEA4D67.8000009@absence.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4DEA4D67.8000009@absence.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 04, 2011 at 05:21:11PM +0200, Marco Chiappero wrote:
> Il 04/06/2011 10:07, Mattia Dongili ha scritto:
> >>of Fn combos too.
> >
> >the additional key codes are fine though.
> 
> There is one thing (IIRC you already heard of) I'd like to discuss here.
> It seems that on recent models the hotkeys layout hasn't changed for
> some time now, and it's likely to stay the same for a long time.
> However it is different from the one mapped in the driver, and some
> changes are required. For example:
> 
> - Fn-F1 (Touchpad togle enable) to KEY_TOUCHPAD_TOGGLE instead of KEY_FN_F1
> - Fn-F5 (bright. down) to KEY_BRIGHTNESSDOWN instead of KEY_FN_F5
> - Fn-F9 (zoom out) to KEY_ZOOMOUT instead of KEY_FN_F9
> and so on.
> 
> To preserve support for older models we can use udev keymaps or a
> fallback map for any notebook not starting with the "VPC" model
> prefix (since a couple of years this is the starting model string).
> Is this solution acceptable? Having a correct mapping at the source
> instead of remapping for every model is better, is it possible?

sure it's possible but it's going to be a source of headache once sony
changes their keyboard layout again (and it will happen).
Using generic key codes and remapping them in userspace where necessary
worked for more than 10 years and is still working fine.

-- 
mattia
:wq!

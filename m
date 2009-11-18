Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:43588 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbZKRQFG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 11:05:06 -0500
Subject: Re: [PATCH 2/2] Adding kerneldoc entry for radio type GPS
From: Marcel Holtmann <marcel@holtmann.org>
To: Janakiram Sistla <janakiram.sistla@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <4fb5db50911180755u4e01814bvcc4d0ec8d396abd@mail.gmail.com>
References: <1258557771-10776-1-git-send-email-janakiram.sistla@gmail.com>
	 <1258558500.2003.88.camel@violet>
	 <4fb5db50911180755u4e01814bvcc4d0ec8d396abd@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Nov 2009 17:05:10 +0100
Message-ID: <1258560310.2003.91.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Janakiram,

> >>
> >> diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> >> index d787d5f..212f555 100644
> >> --- a/include/linux/rfkill.h
> >> +++ b/include/linux/rfkill.h
> >> @@ -36,6 +36,7 @@
> >>   * @RFKILL_TYPE_WIMAX: switch is on a WiMAX device.
> >>   * @RFKILL_TYPE_WWAN: switch is on a wireless WAN device.
> >>   * @RFKILL_TYPE_FM: switch is on a FM device.
> >> + * @RFKILL_TYPE_GPS: switch is on a GPS device.
> >>   * @NUM_RFKILL_TYPES: number of defined rfkill types
> >>   */
> >>  enum rfkill_type {
> >
> > so this is getting stupid right now. I am sick of a really simple patch
> > causes so much trouble. Even this one is wrong again. The GPS doc should
> > obviously before FM.
> Marcel I think you want me to submit GPS doc patch first.I will be
> doing it shortly and then i will do it for FM.I am sorry for this mis
> understanding

I don't care in which order you submit the patches, but the order of the
documentation should match the order in the enum. That is not a strict
requirement, but here it makes total sense to do so.

Also don't worry with the patches anymore. This took way too much ping
pong to get it right, that I just wrote them by myself and submitted
them for inclusion.

Regards

Marcel



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:34279 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbZKHOso (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 09:48:44 -0500
Received: by ewy3 with SMTP id 3so2402646ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 06:48:49 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH] rt2500usb: remove dead link tuning code
Date: Sun, 8 Nov 2009 15:12:52 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <200911081443.35448.bzolnier@gmail.com> <200911081450.35804.IvDoorn@gmail.com>
In-Reply-To: <200911081450.35804.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200911081512.52140.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009 14:50:35 Ivo van Doorn wrote:
> On Sunday 08 November 2009, Bartlomiej Zolnierkiewicz wrote:
> > Link tuning code from the legacy rt2570 driver turned out to be
> > harmful and got disabled by the commit d06193f ("rt2x00: Disable
> > link tuning in rt2500usb") in August 2008.
> > 
> > There is no reason to keep this dead code any longer so remove it
> > (it can still be retrieved from the git history if necessary).
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Please keep this code. There is no particular reason to delete it,
> and at the moment I prefer this code to be kept close at hand.

It is trivial to see/retrieve the deleted code using git when there
is a specific need for it.

OTOH having it visible in the current tree distributed to _thousands_
of developers serves as a distraction and waste of people's time..

-- 
Bartlomiej Zolnierkiewicz

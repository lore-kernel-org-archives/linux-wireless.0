Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:62014 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbZKHNuc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 08:50:32 -0500
Received: by ewy3 with SMTP id 3so2376272ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 05:50:37 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] rt2500usb: remove dead link tuning code
Date: Sun, 8 Nov 2009 14:50:35 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <200911081443.35448.bzolnier@gmail.com>
In-Reply-To: <200911081443.35448.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911081450.35804.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009, Bartlomiej Zolnierkiewicz wrote:
> Link tuning code from the legacy rt2570 driver turned out to be
> harmful and got disabled by the commit d06193f ("rt2x00: Disable
> link tuning in rt2500usb") in August 2008.
> 
> There is no reason to keep this dead code any longer so remove it
> (it can still be retrieved from the git history if necessary).
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Please keep this code. There is no particular reason to delete it,
and at the moment I prefer this code to be kept close at hand.

Ivo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:47685 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbZKHNtN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 08:49:13 -0500
Received: by ewy3 with SMTP id 3so2375631ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 05:49:17 -0800 (PST)
Message-ID: <4AF6CC51.2060500@gmail.com>
Date: Sun, 08 Nov 2009 14:49:05 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH] rt2500usb: remove dead link tuning code
References: <200911081443.35448.bzolnier@gmail.com>
In-Reply-To: <200911081443.35448.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/09 14:43, Bartlomiej Zolnierkiewicz wrote:
> Link tuning code from the legacy rt2570 driver turned out to be
> harmful and got disabled by the commit d06193f ("rt2x00: Disable
> link tuning in rt2500usb") in August 2008.
> 
> There is no reason to keep this dead code any longer so remove it
> (it can still be retrieved from the git history if necessary).
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

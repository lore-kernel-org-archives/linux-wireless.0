Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59173 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1CCLum convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 06:50:42 -0500
Received: by wwb22 with SMTP id 22so1241521wwb.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 03:50:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <op.vrqdhre53ri7v4@arend-laptop>
References: <1298840055-5044-1-git-send-email-martinez.javier@gmail.com> <op.vrqdhre53ri7v4@arend-laptop>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Thu, 3 Mar 2011 12:50:26 +0100
Message-ID: <AANLkTik2y0ULwpDXNm+GzvXw0NGRpj0gUjbdBhjcO_1z@mail.gmail.com>
Subject: Re: [PATCH 1/2] staging: brcm80211: Add buf_size parameter to
 ampdu_action handler function
To: Arend van Spriel <arend@broadcom.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>
> This currently gives a warning on staging-next branch:
>
> drivers/staging/brcm80211/brcmsmac/wl_mac80211.c:699: warning:
> initialization from incompatible pointer type
>
>
> Probably you have used a newer net/mac80211.h as reference which has not yet
> landed on the staging-next branch.
>
> Gr. AvS
> --

Hi Arend,

I tried to compile the driver in today linux-next (which already has
the patch applied) and doesn't gives any warning.

Please tell me if you still are having issues with it.

Thanks a lot.

-- 
-----------------------------------------
Javier Martínez Canillas
(+34) 682 39 81 69
PhD Student in High Performance Computing
Computer Architecture and Operating System Department (CAOS)
Universitat Autònoma de Barcelona
Barcelona, Spain

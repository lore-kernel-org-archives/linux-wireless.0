Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57581 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab0IMRhS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 13:37:18 -0400
Received: by wyf22 with SMTP id 22so6446550wyf.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Sep 2010 10:37:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C88F8CE.5090708@broadcom.com>
References: <20100908150322.17dac9c3@nehalam>
	<20100908225132.GA12490@kroah.com>
	<4C88F8CE.5090708@broadcom.com>
Date: Mon, 13 Sep 2010 12:36:57 -0500
Message-ID: <AANLkTikRuBq9imY43SBmeAFvO7GDVxVrMGEjRc+J3ZOV@mail.gmail.com>
Subject: Re: [ANN] Full-source Broadcom wireless driver for 11n chips
From: Qasim Javed <qasimj@gmail.com>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wow, very excited about Broadcom taking this step.

Thanks for the efforts of everyone involved in this.

-Qasim

On Thu, Sep 9, 2010 at 10:10 AM, Henry Ptasinski <henryp@broadcom.com> wrote:
> Broadcom would like to announce the initial release of a fully-open
> Linux driver for it's latest generation of 11n chipsets.  The driver,
> while still a work in progress, is released as full source and uses the
> native mac80211 stack.   It supports multiple current chips (BCM4313,
> BCM43224, BCM43225) as well as providing a framework for supporting
> additional chips in the future, including mac80211-aware embedded chips.
>  The README and TODO files included with the sources provide more
> details about the current feature set, known issues, and plans for
> improving the driver.
>
> The driver is currently available in staging-next git tree, available at:
>
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
>
> in the drivers/staging/brcm80211 directory.
>
> ---
> Henry Ptasinski
> henryp@broadcom.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

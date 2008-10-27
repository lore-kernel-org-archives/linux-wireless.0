Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:48675 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752462AbYJ0Ttg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 15:49:36 -0400
Date: Mon, 27 Oct 2008 11:56:34 -0700
From: Greg KH <greg@kroah.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] at76_usb: update drivers/staging/at76_usb w/ mac80211
	port
Message-ID: <20081027185634.GA21649@kroah.com> (sfid-20081027_204948_622804_A2C9F85A)
References: <1224877739-1586-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1224877739-1586-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 24, 2008 at 03:48:59PM -0400, John W. Linville wrote:
> This updates drivers/staging/at76_usb to correspond with the latest
> version previously available in wireless-testing.
>=20
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

I've applied this, but it does add the following warnings, which I don'=
t
think you want to have:
	drivers/staging/at76_usb/at76_usb.c:885: warning: =E2=80=98at76_set_as=
socid=E2=80=99 defined but not used
	drivers/staging/at76_usb/at76_usb.c:903: warning: =E2=80=98at76_set_li=
sten_interval=E2=80=99 defined but not used
	drivers/staging/at76_usb/at76_usb.c:989: warning: =E2=80=98at76_add_ma=
c_address=E2=80=99 defined but not used


I'll remove these unused functions now from the in-kernel version.

Is there any way to do development on this in the staging version now,
instead of the wireless-testing tree?

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:49115 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab0ABRqs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2010 12:46:48 -0500
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH] b43: Add new SSB's core id for BCM4328
Date: Sat, 2 Jan 2010 18:46:27 +0100
Cc: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <op.u5wyi5dd9lhzdc@linux-g0th.site> <69e28c911001020826q575f65fbp6b48232e83392dcb@mail.gmail.com>
In-Reply-To: <69e28c911001020826q575f65fbp6b48232e83392dcb@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201001021846.29382.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 02 January 2010 17:26:55 Gábor Stefanik wrote:
> > @@ -110,6 +110,7 @@ static const struct ssb_device_id b43_ssb_tbl[] = {
> >        SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 9),
> >        SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 10),
> >        SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 11),
> > +       SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 12),
> 
> Rev.14 is also missing (which AFAIK is used by some LP cards).

"AFAIK" doesn't count.
We only add IDs for cards that do actually exist in reality.
So do you have such a card or a report by someone owning one?

-- 
Greetings, Michael.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63724 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab1KNPIs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 10:08:48 -0500
Received: by yenr9 with SMTP id r9so5227564yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2011 07:08:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EBEA616.2020002@01019freenet.de>
References: <4EBEA616.2020002@01019freenet.de>
Date: Mon, 14 Nov 2011 16:08:47 +0100
Message-ID: <CAGXE3d8X8N9VVLZCmyyGrwVhD-3BQJKcnY=nWmE+0h68dnWMBg@mail.gmail.com> (sfid-20111114_160851_422242_B096C5AC)
Subject: Re: Try to narrow down the problem with rt2800usb and rt3572 based
 USB WLAN devices
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: users@rt2x00.serialmonkey.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 12, 2011 at 6:00 PM, Andreas Hartmann
<andihartmann@01019freenet.de> wrote:
> Could anybody please try to explain this behavior, or even better, fix
> it (it looks really broken to me)?

AFAIK it is possible to aggregate  multiple frames into one URB
for rt2800 USB devices. However, rt2800usb doesn't make use
of this yet while the legacy driver does. However, I don't think that
this is the cause for the poor performance you see ...

Helmut

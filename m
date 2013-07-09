Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:56745 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab3GIMmY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 08:42:24 -0400
Received: by mail-pb0-f53.google.com with SMTP id xb12so5475244pbc.26
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jul 2013 05:42:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51DBF389.5060209@inov.pt>
References: <51DB0ACC.7050800@inov.pt> <CA+XVXfcakDiN1pPqGDQAN=VR8p_C1LUWGt_nX-rGXDLsBkk+Dw@mail.gmail.com>
 <51DB4195.8090103@inov.pt> <CA+XVXffKKVMeD5GXkzDsnvR7=Ocb8QP0Y7eeD-ZZTzsxJL7PqA@mail.gmail.com>
 <1373360959.21065.183.camel@cumari.coelho.fi> <51DBD904.6020007@inov.pt>
 <1373362817.21065.191.camel@cumari.coelho.fi> <51DBF389.5060209@inov.pt>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 9 Jul 2013 15:42:08 +0300
Message-ID: <CA+XVXfeB3jpXaaV4vgbHUVRdPeH9tPVRWvRhZsYHmg33HNzmmw@mail.gmail.com> (sfid-20130709_144238_843600_04E6F416)
Subject: Re: wl127x: Unable to associate with a WPA2-PSK AP
To: =?ISO-8859-1?Q?Jos=E9_Miguel_Gon=E7alves?= <jose.goncalves@inov.pt>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 9, 2013 at 2:27 PM, José Miguel Gonçalves
<jose.goncalves@inov.pt> wrote:

> Any more ideas on how to debug this? Is there any specific debug_level mask
> that can apply to the driver to help it?

You can try the mask 0x63c20 (it's pretty verbose, so I would put it
in pastebin).

Perhaps this is a genuine problem with the antenna of the card? Can
you verify the RSSI of the AP is ok using iw?

Arik

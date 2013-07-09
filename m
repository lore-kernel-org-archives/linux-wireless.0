Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lmv.inov.pt ([146.193.64.2]:37828 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739Ab3GINWa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 09:22:30 -0400
Message-ID: <51DC0E7C.9080306@inov.pt> (sfid-20130709_152234_090271_D11354B0)
Date: Tue, 09 Jul 2013 14:22:04 +0100
From: =?ISO-8859-1?Q?Jos=E9_Miguel_Gon=E7alves?= <jose.goncalves@inov.pt>
MIME-Version: 1.0
To: Arik Nemtsov <arik@wizery.com>
CC: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Subject: Re: wl127x: Unable to associate with a WPA2-PSK AP
References: <51DB0ACC.7050800@inov.pt> <CA+XVXfcakDiN1pPqGDQAN=VR8p_C1LUWGt_nX-rGXDLsBkk+Dw@mail.gmail.com> <51DB4195.8090103@inov.pt> <CA+XVXffKKVMeD5GXkzDsnvR7=Ocb8QP0Y7eeD-ZZTzsxJL7PqA@mail.gmail.com> <1373360959.21065.183.camel@cumari.coelho.fi> <51DBD904.6020007@inov.pt> <1373362817.21065.191.camel@cumari.coelho.fi> <51DBF389.5060209@inov.pt> <CA+XVXfeB3jpXaaV4vgbHUVRdPeH9tPVRWvRhZsYHmg33HNzmmw@mail.gmail.com>
In-Reply-To: <CA+XVXfeB3jpXaaV4vgbHUVRdPeH9tPVRWvRhZsYHmg33HNzmmw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09-07-2013 13:42, Arik Nemtsov wrote:
> On Tue, Jul 9, 2013 at 2:27 PM, José Miguel Gonçalves
> <jose.goncalves@inov.pt> wrote:
>
>> Any more ideas on how to debug this? Is there any specific debug_level mask
>> that can apply to the driver to help it?
> You can try the mask 0x63c20 (it's pretty verbose, so I would put it
> in pastebin).
>
> Perhaps this is a genuine problem with the antenna of the card?

Nope. The AP is 1 meter away form my board (even without antenna in the 
card it should associate).

> Can
> you verify the RSSI of the AP is ok using iw?

The iw output:

http://pastebin.com/XmEzqjHs

The dmesg output with debug mask set to 0x63c20:

http://pastebin.com/zGE0Gfp8

Note that with debug activated I did not see the driver's "Beacon loss 
detected" messages.

José Gonçalves

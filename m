Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.211.182]:54816 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZLUPdL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 10:33:11 -0500
Received: by ywh12 with SMTP id 12so5714563ywh.21
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2009 07:33:11 -0800 (PST)
Message-ID: <4B2F9534.8020908@lwfinger.net>
Date: Mon, 21 Dec 2009 09:33:08 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mike Marchywka <marchywka@hotmail.com>
CC: netrolller.3d@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: I need a card that works reasonably easily with Debain- reccs?
References: <BLU113-W7635FBD7855C5257B07E4BE820@phx.gbl>,<69e28c910912210614v31edf6cej9abeddb17ab130d@mail.gmail.com> <BLU113-W10113EE534A08128E43979BE820@phx.gbl>
In-Reply-To: <BLU113-W10113EE534A08128E43979BE820@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/21/2009 08:51 AM, Mike Marchywka wrote:
> 
> 
> 
> Thanks.
> As near as I can tell from the driver files it should be a netgear WG311v3
> 802.11g. May be a card mismatch but I'd have to pull machine apart to check.
> 
> Are there known issues with ndiswrapper or I shouldn't even ask here? LOL.
> 
> If there are known easy/difficult cards on a faq/list somewhere I thought that
> would help as driver support seems to be a big issue.

Before you rip the machine apart, use lsusb or 'lspci -nn' to get the
USB or PCI IDs for the device.

Most of us saw far too many Windows Blue Screens of Death to allow any
Windows code unchecked access to the inner rings of Linux, which is
exactly what ndiswrapper does.

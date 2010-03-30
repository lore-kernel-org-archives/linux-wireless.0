Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37654 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab0C3RsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 13:48:06 -0400
Received: by mail-vw0-f46.google.com with SMTP id 20so895732vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Mar 2010 10:48:05 -0700 (PDT)
Message-ID: <4BB23953.9010104@lwfinger.net>
Date: Tue, 30 Mar 2010 12:48:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: Broadcom card totally not visible for system (lspci)
References: <b170af451003300956r7fbd7812jdb40d125aeaf1b32@mail.gmail.com>	 <4BB2328D.9010503@lwfinger.net> <b170af451003301031yd06f559j85fd30417af32113@mail.gmail.com>
In-Reply-To: <b170af451003301031yd06f559j85fd30417af32113@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/30/2010 12:31 PM, Rafał Miłecki wrote:
> 
> Is this possible it's disabled in BIOS by default and needs execution
> of some ACPI command or sth to make it work?
> 
> Yeah, trying to find some other reason than faulty WiFi... It's weird
> it was working fine "before a moment" on Windows.

Winblows can fiddle with the "Wake-on-LAN" setting in the BIOS, but AFAIK, the
BCM4306 does not have this capability. If the BIOS has that setting, it should
be turned off.

Larry


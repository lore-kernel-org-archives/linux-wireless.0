Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:39463 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbYEVFY0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 01:24:26 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1874697ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 May 2008 22:24:17 -0700 (PDT)
Message-ID: <445f43ac0805212218o3d75f52atbee5e13e24a036e0@mail.gmail.com> (sfid-20080522_072430_512799_1570B2F5)
Date: Wed, 21 May 2008 22:18:07 -0700
From: "Javier Cardona" <javier@cozybit.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [PATCH 2/2] Sysfs interface for accessing non-volatile configuration.
Cc: "David Woodhouse" <dwmw2@infradead.org>, carrano@laptop.org,
	dilinger@queued.net, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
In-Reply-To: <1211400311.4232.33.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4832422a.20018e0a.6b37.3217@mx.google.com>
	 <1211292718.21380.238.camel@pmac.infradead.org>
	 <445f43ac0805211159u317bf720vd88d29a504445ba6@mail.gmail.com>
	 <1211396780.21380.368.camel@pmac.infradead.org>
	 <445f43ac0805211218v58d33458v41d0d11f98ed4f14@mail.gmail.com>
	 <1211398105.21380.371.camel@pmac.infradead.org>
	 <445f43ac0805211251v12f49c26j540bf3763bc4dd27@mail.gmail.com>
	 <1211400311.4232.33.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan,

On Wed, May 21, 2008 at 1:05 PM, Dan Williams <dcbw@redhat.com> wrote:
> And they probably don't respond to USB port resets either, do they?

Don't think so.

> Our recovery mode was always:
>
> 1) CMD_802_11_RESET
> 2) if that didn't work, do a USB port reset

I don't think this ever worked on an active antenna in standalone
mode.  This may have been the recovery mode for firmware/usb problems.

Javier


-- 
Javier Cardona
cozybit Inc.

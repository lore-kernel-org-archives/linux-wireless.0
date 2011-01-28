Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.115.56]:33729 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754690Ab1A1QtJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 11:49:09 -0500
Received: from chimera.site ([173.50.240.230]) by xenotime.net for <linux-wireless@vger.kernel.org>; Fri, 28 Jan 2011 08:49:06 -0800
Date: Fri, 28 Jan 2011 08:49:06 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: James <bjlockie@lockie.ca>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: enable CONFIG_WIRELESS_EXT
Message-Id: <20110128084906.53c7c555.rdunlap@xenotime.net>
In-Reply-To: <4D42E9C0.2050809@lockie.ca>
References: <4D41DAF1.6080204@lockie.ca>
	<4D41ED24.9010005@hauke-m.de>
	<4D41FDF7.3040805@lockie.ca>
	<AANLkTimG_46nLNAurBGfDEPdZwnUmKE3GPFOMWxC0UX0@mail.gmail.com>
	<4D42E9C0.2050809@lockie.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 28 Jan 2011 11:07:28 -0500 James wrote:

> On 01/27/11 18:39, Brian Prodoehl wrote:
> > How are you trying to bring up the interface, in order to use dhcpcd
> > on it?  Anyways, I would say that, yes, you do need
> > CONFIG_WIRELESS_EXT.
> >
> > -Brian
> >
> I had to enable Device Drivers->Network device support->Wireless
> LAN->Intel PRO/Wireless 2100 Network Connection  to get
> CONFIG_WIRELESS_EXT=y
> I propose there should be a new obvious kernel option to enable
> CONFIG_WIRELESS_EXT.


What wireless driver are you using?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

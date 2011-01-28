Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:47954 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947Ab1A1QHb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 11:07:31 -0500
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-36.nexicom.net [216.168.118.36])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p0SG7SWx014346
	for <linux-wireless@vger.kernel.org>; Fri, 28 Jan 2011 11:07:29 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 6582998571
	for <linux-wireless@vger.kernel.org>; Fri, 28 Jan 2011 11:07:28 -0500 (EST)
Message-ID: <4D42E9C0.2050809@lockie.ca>
Date: Fri, 28 Jan 2011 11:07:28 -0500
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: enable CONFIG_WIRELESS_EXT
References: <4D41DAF1.6080204@lockie.ca>	<4D41ED24.9010005@hauke-m.de>	<4D41FDF7.3040805@lockie.ca> <AANLkTimG_46nLNAurBGfDEPdZwnUmKE3GPFOMWxC0UX0@mail.gmail.com>
In-Reply-To: <AANLkTimG_46nLNAurBGfDEPdZwnUmKE3GPFOMWxC0UX0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/27/11 18:39, Brian Prodoehl wrote:
> How are you trying to bring up the interface, in order to use dhcpcd
> on it?  Anyways, I would say that, yes, you do need
> CONFIG_WIRELESS_EXT.
>
> -Brian
>
I had to enable Device Drivers->Network device support->Wireless
LAN->Intel PRO/Wireless 2100 Network Connection  to get
CONFIG_WIRELESS_EXT=y
I propose there should be a new obvious kernel option to enable
CONFIG_WIRELESS_EXT.


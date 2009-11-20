Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:45774 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbZKTOz1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 09:55:27 -0500
Received: by gxk26 with SMTP id 26so3013164gxk.1
        for <linux-wireless@vger.kernel.org>; Fri, 20 Nov 2009 06:55:33 -0800 (PST)
Message-ID: <4B06ADE1.2000703@lwfinger.net>
Date: Fri, 20 Nov 2009 08:55:29 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ehud Gavron <gavron@wetwork.net>
CC: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH RFC] ssb: Generic SPROM override for devices without SPROM
References: <200911201212.19588.mb@bu3sch.de> <4B06A233.2070708@lwfinger.net> <4B06ACCE.5040503@wetwork.net>
In-Reply-To: <4B06ACCE.5040503@wetwork.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/20/2009 08:50 AM, Ehud Gavron wrote:
> How does WL do it?  Broadcom *has* to generate a MAC address that is
> both unique and in its assigned range.  If we can do the same thing in
> B43 that would be ideal.

They are memory mapping a file in /etc/wlan. How this file is generated is not
known. I looked at the Acer One D250 driver for Windows, but got no clue there.

Larry

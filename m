Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:56366 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbYIFSL7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 14:11:59 -0400
From: Michael Buesch <mb@bu3sch.de>
To: gavron@wetwork.net
Subject: Re: Speed enhancement for BCM4306/2
Date: Sat, 6 Sep 2008 20:11:35 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Broadcom Wireless <bcm43xx-dev@berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
References: <48C1BA91.7050106@lwfinger.net> <48C2A1F5.6020607@lwfinger.net> <48C2C6D3.3030601@wetwork.net>
In-Reply-To: <48C2C6D3.3030601@wetwork.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809062011.35637.mb@bu3sch.de> (sfid-20080906_201202_762655_42271BDA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 06 September 2008 20:07:15 gavron@wetwork.net wrote:
> correct these issues.   I did see several other ways in which the code 
> does not match the specs.  Should that be documented in the code or 
> should the code be conformed to the specs even if that ends up breaking 
> the driver?

You're really considering breaking the driver just to conform the specs?

> Without getting into specifics it's cases where the specs will say "When 
> something=value" but the code says "when variable >=(value -1)".

Please show us the code, so we can give you advise.

-- 
Greetings Michael.

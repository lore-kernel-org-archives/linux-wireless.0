Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:47068 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbZDYOoS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 10:44:18 -0400
From: Christian Lamparter <chunkeey@web.de>
To: eric.valette@free.fr
Subject: Re: Problem loading ar9170 on an atheros dongle
Date: Sat, 25 Apr 2009 16:44:16 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <49F2C543.8030703@free.fr>
In-Reply-To: <49F2C543.8030703@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200904251644.16465.chunkeey@web.de> (sfid-20090425_164422_402408_B493107E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 25 April 2009 10:09:39 Eric Valette wrote:
> Hi,
> 
> I've a dongle thta is marked as supported but I cannot get the driver to
> load correctly.
> 
> Attached the trace at the end of dmesg. I can try patches add traces, ...
> 
> Thanks for the work on this chipset.
> 
check if your firmware md5sum matches those on our wiki site
(see kconfig for link)

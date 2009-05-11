Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38471 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbZEKNqJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 09:46:09 -0400
Date: Mon, 11 May 2009 08:48:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: feldmaus <feldmann_markus@gmx.de>
Cc: linux-wireless@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: hints an infos to start debuging on hp-wmi
Message-ID: <20090511124855.GA2721@tuxdriver.com>
References: <gu4g0g$s1e$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <gu4g0g$s1e$1@ger.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 09, 2009 at 07:55:13PM +0200, feldmaus wrote:

> i had many trouble with the wlan card of my girl friends HP zv5265ea
> Laptop. It is a BCM4303 Wlan Card. The Problem i think is the
> hp-wmi driver, so i want to debug it.

Is the problem related to RF-Kill?  If not, then hp-wmi is probably
not the best place to start...

> It would be nice if someody gives me a start point how to ?
> I currently using the 2.6.29-rc7 kernel sources.
> Which sources or header files do i have to modify ?

./drivers/platform/x86/hp-wmi.c

> Are there any developers documentation for the hp-wmi ?

No idea...

Good luck!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:18338 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbYDNQee convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2008 12:34:34 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: David Anders <dave123_aml@yahoo.com>
Subject: Re: Alternative Libertas SDIO driver seen
Date: Mon, 14 Apr 2008 18:31:34 +0200
Cc: libertas-dev@lists.infradead.org,
	"Harvey, Timothy" <tharvey@irobot.com>, feng.tang@intel.com,
	linux-wireless@vger.kernel.org, claud_yu <claud_yu@yahoo.com.tw>
References: <916547.28931.qm@web54407.mail.yahoo.com>
In-Reply-To: <916547.28931.qm@web54407.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-Id: <200804141831.34183.hs4233@mail.mn-solutions.de> (sfid-20080414_173453_762438_384F9A9A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> the moblin libertas driver is originally based on source
> marvell released for both the OLPC and the UMPC

I understand the history similar to this:

   Marvell driver developed driver
        dropped to OLPC
   Marvell continued internal driver
        Linux community used OLPC driver and
        brought it into a linux mainline acceptable form
   Marvell released 5.0.16 as GPL
        OLPC driver was massaged to support
        USB,CF and somwhat to support SDIO
   Marvell continued internal driver
        Linux community changed OLPC driver
   Marvell released v8 to Intel moblinux
   Marvell continued internal driver
        Linux community changed OLPC driver
   Marvell releases v9 to Intel moblinux


>From some perspective, I find the current libertas driver in 
Linux better (Dan Williams wrote about this).

However, I'd like to compare an early OLPC driver to the v9 that 
is in Intel's moblinux tree. This way we can find out what 
Marvell changed in the meantime and decide which of those 
changes might be beneficial for us.

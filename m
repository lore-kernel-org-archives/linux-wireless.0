Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:7024 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbZGGPtp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 11:49:45 -0400
Subject: Re: dead RT2501USB ?
From: Pavel Roskin <proski@gnu.org>
To: ptb@cs.bham.ac.uk
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
In-Reply-To: <200907071526.n67FQICE002753@barney.it.uc3m.es>
References: <200907071526.n67FQICE002753@barney.it.uc3m.es>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 11:49:43 -0400
Message-Id: <1246981783.23943.10.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-07-07 at 17:26 +0200, Peter Breuer wrote:
> Firstly: lsusb output:
> 
>   Bus 005 Device 002: ID 148f:2573 Ralink Technology, Corp. RT2501USB Wireless Adapter
...
> Loaading the  rt73usb module produces this stack (after a fair old delay
> for the modprobe to come back)
...
> So it thinks it's not the right chipset. Perhaps I should add an
> identification line somewhere in the code?

Try rt2500usb instead of rt73usb.  Both drivers support 148f:2573.  As
far as I know, it's impossible to find out which driver would work with
a particular device from USB ID alone.

-- 
Regards,
Pavel Roskin

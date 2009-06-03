Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:64990 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbZFCFpn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 01:45:43 -0400
From: Ivo van Doorn <ivdoorn@gmail.com>
To: alejandro.riveira@gmail.com
Subject: Re: [2.6.27-rc7 vs 2.6.29 Regresion] Wifi Network Slownes rt2500pci
Date: Wed, 3 Jun 2009 07:45:41 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linville@tuxdriver.com, Greg KH <greg@kroah.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <1243247687.5322.8.camel@varda> <200906022353.44284.IvDoorn@gmail.com> <1243981353.7204.1.camel@varda>
In-Reply-To: <1243981353.7204.1.camel@varda>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200906030745.41827.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 03 June 2009, Alejandro Riveira Fernández wrote:
> El mar, 02-06-2009 a las 23:53 +0200, Ivo van Doorn escribió:
> 
> > > So my chip works better with incorrect values written in its registers?
> > 
> > Apparently, probably because some other register is set to an incorrect value,
> > but I have no idea which one that would be.
> 
> Could the fact that i dual boot with windows (and use the windows
> driver) have someting to do with it ?

Don't think so, unless you notice a difference in behavior when you reboot
from Windows to Linux compared to making a cold-boot or reboot from Linux
to Linux.

Ivo

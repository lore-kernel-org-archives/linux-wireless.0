Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:56421 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab1G2QdJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 12:33:09 -0400
Message-ID: <4E32E0AC.1090108@gnu.org> (sfid-20110729_183313_213295_7B9A63EA)
Date: Fri, 29 Jul 2011 12:32:44 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Martin Partridge <martin_partridge@btconnect.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: help
References: <op.vzcrpnuuhgplxr@melanie> <4E322518.9060209@gnu.org>
In-Reply-To: <4E322518.9060209@gnu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/28/2011 11:12 PM, Pavel Roskin wrote:

> You only need to check if the modules are present in the kernel you are
> using. You can do that by running "modprobe p54".

Sorry, it should be "modproble p54pci" for PCI cards and "modprobe 
p54usb" for USB devices.  I checked Fuduntu, and it has both drivers. 
It doesn't have the firmware, but I guess you have no problems with that 
part of the instructions.

-- 
Regards,
Pavel Roskin

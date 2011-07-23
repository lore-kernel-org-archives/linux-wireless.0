Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:30503 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab1GWHxe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 03:53:34 -0400
Message-ID: <4E2A7DFC.3060401@gnu.org> (sfid-20110723_095344_318388_E07EA595)
Date: Sat, 23 Jul 2011 03:53:32 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: netdev@vger.kernel.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	senthilkumar@atheros.com, vasanth@atheros.com, jmalinen@atheros.com
Subject: Re: [ath9k-devel] [PATCH] ath9k: use pci_dev->subsystem_device
References: <201107221958.23408.sshtylyov@ru.mvista.com>
In-Reply-To: <201107221958.23408.sshtylyov@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/22/2011 11:58 AM, Sergei Shtylyov wrote:
> The driver reads PCI subsystem ID from the PCI configuration register while it's
> already stored by the PCI subsystem in the 'subsystem_device' field of 'struct
> pci_dev'...
>
> Signed-off-by: Sergei Shtylyov<sshtylyov@ru.mvista.com>

subsysid doesn't appear to be used anywhere.  It can be removed easily. 
  The patch will be sent separately.

-- 
Regards,
Pavel Roskin

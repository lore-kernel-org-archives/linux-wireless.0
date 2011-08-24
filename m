Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4309 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab1HXXUB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 19:20:01 -0400
Date: Wed, 24 Aug 2011 16:18:51 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "Aaro Koskinen" <aaro.koskinen@iki.fi>
cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
Message-ID: <20110824231851.GG5280@broadcom.com> (sfid-20110825_012006_277647_ED4F93CB)
References: <20110707002034.GA17885@broadcom.com>
 <20110824222801.GA5280@broadcom.com>
 <C7234C0A-9839-4150-8B25-F6A6771377A1@iki.fi>
MIME-Version: 1.0
In-Reply-To: <C7234C0A-9839-4150-8B25-F6A6771377A1@iki.fi>
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 24, 2011 at 04:10:31PM -0700, Aaro Koskinen wrote:
> Hi,
> 
> On 25.8.2011, at 1.28, Henry Ptasinski wrote:
> > The brcmsmac driver has been verified to work on x86 (both 32- and  
> > 64-bit), PPC
> > (64-bit), SPARC, MIPS BE, and ARM.  The brcmfmac driver has been  
> > verified to
> > work on x86 32-bit and ARM (additional testing is in progress, but  
> > getting a
> > working sdio controller on some of the other platforms has been  
> > challenging).
> >
> > The drivers compile cleanly for x86 (32- and 64-bit), PPC (32- and  
> > 64-bit),
> > SPAR, MIPS BE, MIPS LE, and ARM.
> 
> Are you sure the compilation is even enabled on all of those platforms?
> 
> E.g.:
> 
>  > +config BRCMSMAC
>  > +       tristate "Broadcom IEEE802.11n PCIe SoftMAC WLAN driver"
>  > +       default n
>  > +       depends on PCI
>  > +       depends on WLAN && MAC80211
>  > +       depends on X86 || MIPS
>            ^^^^^^^^^^^^^^^^^^^^^^
> 
> Why this?
> 
> A.
> 
> 

See my other message.  Wrong link to the patch.  Correct link:

http://linuxwireless.org/en/users/Drivers/brcm80211?action=AttachFile&do=get&target=0001-wireless-testing-add-brcm80211-v2.patch

Kicking myself very much right now ...

- Henry



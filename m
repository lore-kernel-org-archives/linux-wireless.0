Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2526 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab2AUJ64 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jan 2012 04:58:56 -0500
Message-ID: <4F1A8C55.6010900@broadcom.com> (sfid-20120121_105859_822637_F79D46C6)
Date: Sat, 21 Jan 2012 10:58:45 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Milan Bouchet-Valat" <nalimilan@club.fr>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BCM4313 doesn't work after suspend (brcmsmac on
 compat-wireless-next)
References: <1327067694.2590.6.camel@milan>
 <4F199EAC.3050602@broadcom.com> <1327080177.3285.26.camel@milan>
In-Reply-To: <1327080177.3285.26.camel@milan>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/20/2012 06:22 PM, Milan Bouchet-Valat wrote:
> Hi and thanks for the reply!
> 
> Le vendredi 20 janvier 2012 à 18:04 +0100, Arend van Spriel a écrit :
>> I am not sure when compat-wireless-next was generated, but several
>> patches were made for suspend/resume.
> It was generated on January 17th, with sources from the 16th. Is that
> recent enough?at

I just checked and the suspend/resume patches from Linus were applied on
January 17th. So you need to pick up the patches (see thread "[0/5]
bcma/brcmsmac suspend/resume cleanups and fixes" on netdev list).

> (Packages are from
> http://people.redhat.com/sgruszka/compat-wireless-next/F-16/)
> 
>> You also need bcma patches. Is
>> bcma included in the compat-wireless package.
> I'm not sure I understand. The bcma module is indeed installed from
> compat-wireless-next and loaded:
> $ lsmod|grep bcma
> bcma                   23804  2 brcmsmac,b43
> 
> $ uname -r
> 3.1.9-1.fc16.x86_64
> 
> $ find /lib/modules/3.1.9-1.fc16.x86_64 -name bcma
> /lib/modules/3.1.9-1.fc16.x86_64/updates/drivers/bcma
> /lib/modules/3.1.9-1.fc16.x86_64/backports/drivers/bcma

That answers my question. bcma is indeed part of compat-wireless.

Gr. AvS


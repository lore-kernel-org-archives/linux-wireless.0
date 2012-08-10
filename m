Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:58735 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab2HJIuS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 04:50:18 -0400
Message-ID: <5024CB44.6040608@neratec.com> (sfid-20120810_105025_862476_0BDE97B9)
Date: Fri, 10 Aug 2012 10:50:12 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Andy Gospodarek <andy@greyhouse.net>
CC: mcgrof@frijolero.org, Phil Perry <phil@elrepo.org>,
	linux-wireless@vger.kernel.org,
	lf driver backport
	<lf_driver_backport@lists.linux-foundation.org>
Subject: Re: [PATCH v2] compat: support RHEL6.3 as a build target
References: <1344487215-24143-1-git-send-email-andy@greyhouse.net> <2121451356.93690.1344518764022.JavaMail.root@neratec.com> <CAHashqCmcgXXDyyqwEYefTMXFDVFKm9GKydfbS14UCY_L443Vg@mail.gmail.com>
In-Reply-To: <CAHashqCmcgXXDyyqwEYefTMXFDVFKm9GKydfbS14UCY_L443Vg@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/09/2012 11:59 PM, Andy Gospodarek wrote:
> On Aug 9, 2012 9:26 AM, "Zefir Kurtisi" <zefir.kurtisi@neratec.com
>> [...]
>> This at least breaks compilation on 2.6.35-22 with gcc throwing a
>> compat-2.6.36.h:104: error: ISO C requires a named argument before ‘...’
>>
> 
> Actually that might be due to the fact that I chose to use
> no_printk(...) rather than no_printk(a,...).
> 
> What version of gcc are you using?
> 
Since you already resolved the issue, just FYI: I'm using
gcc (Ubuntu/Linaro 4.4.4-14ubuntu5.1) 4.4.5





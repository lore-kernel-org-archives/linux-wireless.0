Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:35843 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbcDUUkR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2016 16:40:17 -0400
Received: by mail-ob0-f178.google.com with SMTP id j9so38717734obd.3
        for <linux-wireless@vger.kernel.org>; Thu, 21 Apr 2016 13:40:16 -0700 (PDT)
Date: Thu, 21 Apr 2016 15:40:08 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Anne Marcel Roorda <marcel@density.slowthinkers.net>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: Re: [wireless-regdb] wireless-regdb: Update regulatory rules for
 Germany (DE) on 5GHz
Message-ID: <20160421204008.GF95003@ubuntu-hedt> (sfid-20160421_224026_492653_E39EF129)
References: <1958820.LBuzOElZFT@perisens15>
 <20160421131938.GA95003@ubuntu-hedt>
 <2919568.ssjlN6KUVX@perisens15>
 <20160421185134.GD95003@ubuntu-hedt>
 <20160421201315.9C536206F0@density.slowthinkers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160421201315.9C536206F0@density.slowthinkers.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 21, 2016 at 10:13:14PM +0200, Anne Marcel Roorda wrote:
> 
> On 21 Apr 2016, Seth Forshee wrote:
> > On Thu, Apr 21, 2016 at 08:08:46PM +0200, Maximilian Engelhardt wrote:
> >
> >> The comments to my initial mail indicated that the statement in the ERC 
> >> recommendation I linked are alone not enough to add this frequency ranges for 
> >> other countries. Unfortunately I don't have the possibility to do these checks 
> >> for countries other than Germany.
> >
> >Yep, I understand and am in agreement. I know how challenging it can be
> >to try to track down this information.
> 
>   I could do the same for NL.

That would be great, if anything about the current rules is incorrect or
out of date.

>   At the moment entries for NL are listed as center frequencies
> (almost, 5490 - 5710 @ 160 should be 5550 - 5645 @ 160), while for DE
> the whole band is listed (5470 - 5725 @ 160).

There's no reason per se to limit it to only the range for currently
defined wifi channels if the regulatory body allows unlicensed use of a
wider range. But the rule should include the entire channel bandwith and
not stop at the center frequencies.

>   Power budget is listed in db while the law specifies mW.
> 
>   What is the prefered format, and would a rewrite for NL listing the band
> and power in mW be acceptable ?

It's a direct conversion between the dBm and mW values (in fact mW
values in the text database are converted to dBm values for the binary
database), so the units in the text file don't matter all that much. But
I don't really like changing the units just for the sake of changing
them when the values are already correct; there's always the chance that
some mistake will slip in.

Thanks,
Seth

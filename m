Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:39790 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994AbXH3LQo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 07:16:44 -0400
From: Chr <chunkeey@web.de>
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: Recent linux-wireless git changes have broken my prism54pci card
Date: Thu, 30 Aug 2007 13:16:42 +0200
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>,
	linux-wireless@vger.kernel.org
References: <46BFF10B.1090307@hhs.nl> <200708282132.59474.chunkeey@web.de> <200708300152.27736.flamingice@sourmilk.net>
In-Reply-To: <200708300152.27736.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708301316.42945.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, 30. August 2007, Michael Wu wrote:
> On Tuesday 28 August 2007 15:32, Chr wrote:
> > Here we are:
> >
> > series:
> > p54-pull-padding2.diff
> Looks okay, but it seems to do more than just account for padding. I'm okay 
> with those changes too.
> 
Ok!

> > p54-support-older-firmwares.diff
> The new information pulled from parsing the firmware isn't used anywhere but 
> in this function.. no need to keep that information in the private structure.
> 
Yes, the firmware version string could be freed right after the printk...
but I would like to keep the fw_variant for "further" patches, since the
softmac protocol has changed a bit throughout 2.4 - 2.13.1 firmwares. 

> Thanks,
> -Michael Wu


Thanks,
	Chr. 



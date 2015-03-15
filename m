Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54532 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbbCOUuL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 16:50:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1YXFU4-00059P-BI
	for linux-wireless@vger.kernel.org; Sun, 15 Mar 2015 21:50:04 +0100
Received: from p57938888.dip0.t-ipconnect.de ([87.147.136.136])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 15 Mar 2015 21:50:04 +0100
Received: from juergen.Bausa by p57938888.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 15 Mar 2015 21:50:04 +0100
To: linux-wireless@vger.kernel.org
From: =?utf-8?b?SsO8cmdlbg==?= Bausa <juergen.Bausa@online.de>
Subject: Re: Broadcom 43340
Date: Sun, 15 Mar 2015 20:38:20 +0000 (UTC)
Message-ID: <loom.20150315T213441-211@post.gmane.org> (sfid-20150315_215020_206029_5CBD9FF8)
References: <550482A2.3080803@gmail.com>	<55048833.90408@broadcom.com>	<55048BB1.9080906@gmail.com>	<550491DA.6030105@broadcom.com>	<55049507.6040209@gmail.com> <20150314213907.3f1167bb@mir> <5504B29F.8000305@gmail.com> <55056EFB.9020100@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@...> writes:

> 
> On 03/14/15 23:13, Ochal Christophe wrote:
> > All,
> >
> > On 03/14/2015 09:39 PM, Stefan Lippers-Hollmann wrote:
> >> You don't need to run windows for that, the nvram (calibration data,
> >> probably the MAC address and related device specific data) is stored
> >> in your mainboard's firmware - and exposed to userspace (under linux)
> >> via /sys/firmware/efi/efivars/. You just need to identify the correct
> >> file and copy it to a place where linux expects to find it
> >> (/lib/firmware/brcm/brcmfmac43340-sdio.txt). Regards Stefan
> >> Lippers-Hollmann
> >
> > Thanks for the hint, that did it, I'm online!
> 
> Apparently my hint was not clear enough. Good to hear it works for you.
> 

Dear Arend,

would be nice, if you could make it clear.

I am in the exact some position (asus x205 with linux 4.0 rc3) but my
/sys/firmware/efi/efivars/ is empty. I am running debian jessie with a
kernel taken from ubuntu. Am I missing something? Even loading efivars via
modprobe doesnt change a thing.

Juergen


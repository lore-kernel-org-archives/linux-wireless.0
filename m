Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:48213 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbYHBTKM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 15:10:12 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KPMUT-0000Rs-T8
	for linux-wireless@vger.kernel.org; Sat, 02 Aug 2008 19:10:10 +0000
Received: from gimpelevich.san-francisco.ca.us ([66.218.54.163])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 19:10:09 +0000
Received: from daniel by gimpelevich.san-francisco.ca.us with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 19:10:09 +0000
To: linux-wireless@vger.kernel.org
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Subject: Re: wireless USB adapters recommendations?
Date: Sat, 2 Aug 2008 19:09:55 +0000 (UTC)
Message-ID: <g72be3$gpf$1@ger.gmane.org> (sfid-20080802_211017_111832_D6ADD2A8)
References: <4894AC77.5060801@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 02 Aug 2008 20:50:31 +0200, Tomasz Chmielewski wrote:

> I'm looking for a USB wireless adapter which is well supported under
> Linux.
> 
> Requirements:
> 
> - WPA2
> - should support ad-hoc and access point modes - should work under
> mipsel (I had once a prism54 mini-PCI card which didn't work under
> mipsel)
> 
> It would be also nice to to get the hardware from a producer which
> cooperates with Linux community.
> 
> Do you guys have any recommendations?

Your requirements are mutually exclusive at the moment. Here is what the 
FSF says on the matter:
http://www.fsf.org/resources/hw/net/wireless/cards.html
Access-point mode is now dependent upon nl80211, which isn't finished yet.


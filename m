Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42089 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab1CTJzF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Mar 2011 05:55:05 -0400
Received: by qyk7 with SMTP id 7so1827176qyk.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Mar 2011 02:55:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <op.vslaxakc3ri7v4@arend-laptop>
References: <op.vslagcb13ri7v4@arend-laptop>
	<op.vslaxakc3ri7v4@arend-laptop>
Date: Sun, 20 Mar 2011 10:55:03 +0100
Message-ID: <AANLkTim8SHdE8b9_gFLwbeEJM-uDegBDxU+AUJEb_rfc@mail.gmail.com>
Subject: Re: new utility kernel module for detecting cores in newer chipsets
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Greg KH <greg@kroah.com>,
	linuxdriverproject <devel@linuxdriverproject.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	George Kashperko <george@znau.edu.ua>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/3/19 Arend van Spriel <arend@broadcom.com>:
> + mailing lists
>
> Hi Greg,
>
> There has been several discussion in the community (mainly by b43 and ssb
> developers, I believe) to add support for chip core interconnect used in
> newer Broadcom chips.  Our brcm80211 drivers already have this support and
> we have isolated that functionality in a separate kernel module called
> brcmaxi to provide it to other drivers. Currently, I have it located under
> drivers/staging/brcm80211 as I am not sure whether or not its purpose
> justifies a separate folder (under staging or not).
>
> What are your thoughts about this? I would like to know before submitting
> a patch for this.

Well, I've this AI support rewritten and isolated here too. It's not
about having the code but designing it well.

George Kashperko shared idea of really nice design layout for buses.
He pointed problems with ssb driver, explained how everything works.
With his layout it should be easy to support SSB and AI with very
minimal, if any, additional hacks. Nobody pointed any problems with
his layout.

I don't want to have support for AI in 10 places, even if this is
about staging area.

-- 
Rafał

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45786 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752790AbbJRPpu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2015 11:45:50 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id 9EDC920426
	for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2015 11:45:49 -0400 (EDT)
Date: Sun, 18 Oct 2015 08:45:47 -0700
From: Greg KH <greg@kroah.com>
To: Frans van de Wiel <fvdw@fvdw.eu>
Cc: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
	linux-wireless@vger.kernel.org
Subject: Re: patch for rtl8712 driver, add support for sitecom WLA2100 (006c)
Message-ID: <20151018154547.GA8553@kroah.com> (sfid-20151018_174608_438316_2DE2CBFA)
References: <D805188AF08F4EC2A19325C1329525E0@FransW7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <D805188AF08F4EC2A19325C1329525E0@FransW7>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 18, 2015 at 04:34:51PM +0200, Frans van de Wiel wrote:
> dear sirs, please find attached a patch for the rtl8712 driver (staging)
> The patch add support for  sitecom WLA2100, seems this device id is missing.
> Many dongles use it.
>  
> Kind regards
> Frans



Can you reformat this in the way that the file
Documenatation/SubmittingPatches explains so that I can accept the
patch?  As it is, I can't :(

thanks,

greg k-h

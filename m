Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blaine.gmane.org ([80.91.229.8]:59527 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759443AbYFSRn4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 13:43:56 -0400
Received: from public by hugh.gmane.org with local (Exim 4.63)
	(envelope-from <public@hugh.gmane.org>)
	id 1K9O9Q-00033a-BG
	for linux-wireless@vger.kernel.org; Thu, 19 Jun 2008 19:42:24 +0200
Message-ID: <485A9A00.70700@gmail.com> (sfid-20080619_194426_965406_C5B3A72D)
Date: Thu, 19 Jun 2008 18:40:16 +0100
MIME-Version: 1.0
To: Bernhard Reiter
	<public-bernhard-fZ64t2NdLluOJsaolrKA/Q@hugh.gmane.org>
CC: linux-wireless
	<public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
	Greg KH <public-greg-U8xfFu+wG4EAvxtiuMwx3w@hugh.gmane.org>
Subject: Re: 802.11 pccard, Agere 0x0156,0x0003?
References: <200806181715.20516.bernhard@intevation.de> <4859866A.1090300@gmail.com> <1213833799.5258.13.camel@dv> <200806191023.39851.bernhard@intevation.de>
In-Reply-To: <200806191023.39851.bernhard@intevation.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Bernhard Reiter wrote:
> Ah, I never found that one. Also because the match that this indeed
> is a HermesII card could never be made for sure by myself
> and because that page is only about Hermes I.
> 
> So this is the first indication that the wlags_h2_718 might work
> for the Hermes II card. Where can I download it without registration?
> Why wasn't the 7.22 version used as base for the patch?

The 7.18 Agere driver supports both Hermes I and Hermes II based cards. The 7.22 driver removed support for Hermes I, hence people have concentrated on the 7.18 version.

Both versions can be found at <http://www.xs4all.nl/~pptp/agere>, which also has patched versions for 2.6


Dave.


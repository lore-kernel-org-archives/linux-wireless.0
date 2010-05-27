Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:40365 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756665Ab0E0TUS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 15:20:18 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1OHicn-0006DL-F9
	for linux-wireless@vger.kernel.org; Thu, 27 May 2010 21:20:13 +0200
Received: from g225011133.adsl.alicedsl.de ([92.225.11.133])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 27 May 2010 21:20:13 +0200
Received: from pommnitz by g225011133.adsl.alicedsl.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 27 May 2010 21:20:13 +0200
To: linux-wireless@vger.kernel.org
From: jpo <pommnitz@yahoo.com>
Subject: Re: Regulatory problem with multiple wireless interfaces
Date: Thu, 27 May 2010 19:20:04 +0000 (UTC)
Message-ID: <loom.20100527T211453-173@post.gmane.org>
References: <201005271810.55211.8an@praha12.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lukáš Turek <8an@...> writes:
> What should happen if all cards have different regdomains?

This is a problem I have come across, too. We have the case where we have
an amplifier attached to one WLAN card in a system with two cards. Because
of the amplifier the cards are governed by different rules (available
channels, max output power,...).

Regards
  Joerg


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from reiner-h.de ([83.151.27.91]:38783 "EHLO reiner-h.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756236AbZE1Qh3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 12:37:29 -0400
Message-ID: <4A1EBDDE.9060805@reiner-h.de>
Date: Thu, 28 May 2009 18:37:50 +0200
From: Reiner Herrmann <reiner@reiner-h.de>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: linux-wireless@vger.kernel.org
Subject: Re: mac80211_hwsim: Problem setting up communication
References: <4A1E448E.1030201@reiner-h.de> <20090528145804.GA32743@jm.kir.nu>
In-Reply-To: <20090528145804.GA32743@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen wrote:
> 
> Linux IP/networking stack does not really seem to like connections
> between local interfaces unless this goes through lo.. Or well, at least
> I haven't figured out how to configure this without some kernel code
> changes. It would be kind of nice to get this working, but anyway, I
> made a small program for checking both unicast and broadcast
> communications for this type of use: hwsim_test from
> http://w1.fi/gitweb/gitweb.cgi?p=hostap.git;a=tree;f=mac80211_hwsim/tools
> 
> (it uses packet sockets bound to the interface and does not rely on the
> kernel IP stack)
> 

Thank you, it's working fine. Now I can also test with data frames. :)

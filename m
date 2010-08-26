Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51883 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab0HZP2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Aug 2010 11:28:11 -0400
Subject: Re: a simple wireless mesh network
From: Johannes Berg <johannes@sipsolutions.net>
To: Joel Fernandes <agnel.joel@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTimNA_i8Za8xOh8XffdkrE7wFLc9GBs4JSPAsT3+@mail.gmail.com>
References: <AANLkTimNA_i8Za8xOh8XffdkrE7wFLc9GBs4JSPAsT3+@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Aug 2010 17:28:10 +0200
Message-ID: <1282836490.3812.66.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-08-26 at 10:19 -0500, Joel Fernandes wrote:
> Hi,
> I am studying wireless mesh networks and wanted to play with open80211s.
> As a part of my study, I want to demo, multiple nodes on a mesh
> network and analyze the traffic in wireshark
> 
> Unfortunately I don't have many physical nodes so I'm looking for a
> way to emulate them.
> 
> So far I've learnt that vmware and virtual box don't support virtual
> wireless network adapters.
> 
> Any other suggestion that would make creating a wireless mesh network
> for study purposes quick and painless?

http://wireless.kernel.org/en/users/Drivers/mac80211_hwsim

plus network namespaces, on a very new kernel where that actually works
(like current wireless-testing)

johannes


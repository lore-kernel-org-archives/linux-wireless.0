Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46534 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab0HZP3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Aug 2010 11:29:40 -0400
Date: Thu, 26 Aug 2010 11:24:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Joel Fernandes <agnel.joel@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: a simple wireless mesh network
Message-ID: <20100826152439.GA2464@tuxdriver.com>
References: <AANLkTimNA_i8Za8xOh8XffdkrE7wFLc9GBs4JSPAsT3+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTimNA_i8Za8xOh8XffdkrE7wFLc9GBs4JSPAsT3+@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 26, 2010 at 10:19:23AM -0500, Joel Fernandes wrote:
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

mac80211_hwsim claims mesh support...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:58676 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752206AbYCLVfT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 17:35:19 -0400
Received: from c83-252-237-4.bredband.comhem.se ([83.252.237.4]:53917 helo=tippex.mynet.homeunix.org)
	by ch-smtp02.sth.basefarm.net with esmtp (Exim 4.68)
	(envelope-from <aeriksson@fastmail.fm>)
	id 1JZYbW-0000zM-7g
	for linux-wireless@vger.kernel.org; Wed, 12 Mar 2008 22:35:18 +0100
Received: from tippex (localhost [127.0.0.1])
	by tippex.mynet.homeunix.org (Postfix) with ESMTP id 3C1A62DC045
	for <linux-wireless@vger.kernel.org>; Wed, 12 Mar 2008 22:35:15 +0100 (CET)
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: bulk vs. interactive bandwidth
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 12 Mar 2008 22:35:15 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080312213515.3C1A62DC045@tippex.mynet.homeunix.org> (sfid-20080312_213524_037255_9B6BEC6C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

I have an issue which I can't really narrow down and it might be wlan related. 
It occurs both from a couple of PCs sharing a rt2500 to the internet, and a 
iwl3945 (no sharing) to the net.

The thing is that, normal sufing works ok. But, whenever there is a big 
download going on (say grabbing a kernel tarball), the interactive performace 
drops to pretty much nothing. Getting a prompt from ssh can take close to a 
minute. I'm thinking tha, tperhaps, there is someting buffer related which makes 
the wlan buffers "deeper than normal" and thus makes it hard for the 
interactive tcp's to crate room for themselves in the transmission queues or 
somehting.

I can't recall seeing this phenomenon over a wired connection (with roughly 
the same link bandwidths.)

Dows this sound at all familiar? If so, what's the cure? (I'd rather not go 
into traffic shaping...)

/Anders


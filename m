Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33654 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760599Ab2COJUJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 05:20:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1S86qu-0003AI-Et
	for linux-wireless@vger.kernel.org; Thu, 15 Mar 2012 10:20:08 +0100
Received: from proxyext.iabg.de ([proxyext.iabg.de])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2012 10:20:08 +0100
Received: from pommnitz by proxyext.iabg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2012 10:20:08 +0100
To: linux-wireless@vger.kernel.org
From: jpo <pommnitz@yahoo.com>
Subject: Wireless rate selection and antenna ports
Date: Thu, 15 Mar 2012 09:16:33 +0000 (UTC)
Message-ID: <loom.20120315T101211-95@post.gmane.org> (sfid-20120315_102016_984465_3F211DB8)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,
I'd like to present and maybe get a little bit feedback from the community for a
rather unique problem we face in a production environment. We are using Atheros
AR5312 based EMP-8602 PLUS-S cards in 802.11a mode (5GHz/BBDR) with an external
TX amplifier attached to one of the antenna ports. The second antenna port is
not amplified. Normally we achieve good results with this setup (up to 2km range
outdoors). Unfortunately it doesn't work well if sender and receiver are close
together. In this case the amplified signal is apparently to strong for the card
to handle. However, switching to the antenna port without the amplifier gives
very good results at close range.
Now we are looking for a way to automatically select the best antenna port. It
seems to me, that this problem is closely related to the rate selection problem
faced by the 802.11 stack, so enhancing one of the rate selection algorithms to
include the antenna into the search space might be the way to go.
Has anybody ever done this? Do you think that this might be the way to go? Are
there better heuristics to find the best antenna port? Any other comments?

Thanks in advance
  Joerg



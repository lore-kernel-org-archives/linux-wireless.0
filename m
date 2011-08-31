Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:54200 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680Ab1HaBvz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 21:51:55 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1QyZy1-0007Jx-UX
	for linux-wireless@vger.kernel.org; Wed, 31 Aug 2011 03:51:49 +0200
Received: from 184.175.5.191 ([184.175.5.191])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 03:51:49 +0200
Received: from dennisn by 184.175.5.191 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 03:51:49 +0200
To: linux-wireless@vger.kernel.org
From: Dennis Nezic <dennisn@dennisn.dyndns.org>
Subject: ipw2200 antenna selection
Date: Tue, 30 Aug 2011 21:51:35 -0400
Message-ID: <20110830215135.db381ecf.dennisn@dennisn.dyndns.org> (sfid-20110831_035206_051062_42DEF5C5)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My ipw2200 pcie wifi card has 2 antennas... "Main" and "Aux". I think
either the firmware or the kernel/module is overriding my explicit
antenna module setting, after a while.

I mentioned about it a few days ago,
http://marc.info/?l=linux-wireless&m=131448481319374&w=2
although I'm still seeing the problem (even after physically
disconnecting the Aux antenna/wire. (Even after disconnecting it, I
think it is still able to receive the 30KB/s signal, and I think the
card still switches to it eventually, against my wishes.))


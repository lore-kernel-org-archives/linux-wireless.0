Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44518 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605AbcBCUZI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 15:25:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1aR3z7-0002hA-9P
	for linux-wireless@vger.kernel.org; Wed, 03 Feb 2016 21:25:06 +0100
Received: from abts-north-dynamic-147.150.161.122.airtelbroadband.in ([abts-north-dynamic-147.150.161.122.airtelbroadband.in])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 03 Feb 2016 21:25:05 +0100
Received: from Neelansh by abts-north-dynamic-147.150.161.122.airtelbroadband.in with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 03 Feb 2016 21:25:05 +0100
To: linux-wireless@vger.kernel.org
From: Neelansh Mittal <Neelansh@gmail.com>
Subject: =?utf-8?b?QWRqdXN0aW5nX3RidHQ=?= in mesh capability
Date: Wed, 3 Feb 2016 20:18:40 +0000 (UTC)
Message-ID: <loom.20160203T210737-307@post.gmane.org> (sfid-20160203_212512_948710_5A831675)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, for a mesh node ,the mac80211 
sync implementation sets the tbtt 
adjustment bit , when it is adjusting it's 
tsf as part of Neighbour offset 
Synchronization(Function:mesh_sync_offset_
adjust_tbtt())
According to ieee80211s specification, 
this bit should(only) be set when tbtt 
adjustment procedure(as part of tbtt 
selection/mbca) is ongoing.
So why does mac80211 set it as part of 
Offset syncronization, ie , what is 
advantage the when a mesh node announces  
that "my tbtt will be delayed" to it's 
peers?




Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:54857 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab0IFINC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Sep 2010 04:13:02 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1OsWoy-0000jf-J5
	for linux-wireless@vger.kernel.org; Mon, 06 Sep 2010 10:12:56 +0200
Received: from ppp121-44-8-149.lns20.syd6.internode.on.net ([121.44.8.149])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 06 Sep 2010 10:12:56 +0200
Received: from msbroadf by ppp121-44-8-149.lns20.syd6.internode.on.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 06 Sep 2010 10:12:56 +0200
To: linux-wireless@vger.kernel.org
From: Michael <msbroadf@gmail.com>
Subject: Re: =?utf-8?b?cnQyeDAwdXNiX3dhdGNoZG9nX3R4X3N0YXR1czo=?= Warning - TX queue 2 status timed out, invoke forced tx handler
Date: Mon, 6 Sep 2010 08:12:46 +0000 (UTC)
Message-ID: <loom.20100906T101020-999@post.gmane.org>
References: <loom.20100906T041329-313@post.gmane.org> <AANLkTi=5P8N6QDDZkVuFwCMDzBTLsCkiOem0_WwL-hvS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So Ralink have some fundamental bug in their DMA mechanism....Actually I did
notice this DMA issue does occur less frequently than the TX issue.  Im happy to
run any tests that are needed to get this code more robust.  Thanks. Michael

Ivo Van Doorn <ivdoorn@...> writes:



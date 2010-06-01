Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:37408 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580Ab0FAPjI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 11:39:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1OJTYS-0008Bv-Qc
	for linux-wireless@vger.kernel.org; Tue, 01 Jun 2010 17:39:01 +0200
Received: from 56-88.dial.nortenet.pt ([212.13.56.88])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 17:39:00 +0200
Received: from subscriptions by 56-88.dial.nortenet.pt with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 17:39:00 +0200
To: linux-wireless@vger.kernel.org
From: doddel <subscriptions@stroomer.com>
Subject: Re: mac80211 rx.c: in recent builds bridging between stations associated to an AP does not work
Date: Tue, 1 Jun 2010 15:38:45 +0000 (UTC)
Message-ID: <loom.20100601T173508-447@post.gmane.org>
References: <loom.20100531T230843-554@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The effect may be caused by the newly introduced capability to set the
DO_NOT_BRIDGE parameter via nl80211 (thanks for that !).
The user-space tool iw however does not yet support setting this parameter. 


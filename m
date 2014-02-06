Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56928 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbaBFTkH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Feb 2014 14:40:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1WBUnr-0001Lr-B1
	for linux-wireless@vger.kernel.org; Thu, 06 Feb 2014 20:40:04 +0100
Received: from r200-40-34-107.static.adinet.com.uy ([200.40.34.107])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 06 Feb 2014 20:40:03 +0100
Received: from dromerofre by r200-40-34-107.static.adinet.com.uy with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 06 Feb 2014 20:40:03 +0100
To: linux-wireless@vger.kernel.org
From: Diego Romero <dromerofre@gmail.com>
Subject: help with hostapd.conf
Date: Thu, 6 Feb 2014 19:37:36 +0000 (UTC)
Message-ID: <loom.20140206T203713-711@post.gmane.org> (sfid-20140206_204027_020230_95422A12)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've marked traffic with DSCP and have hostapd running as AP. 

There are 4 queues defined into hostapd.conf, but how should hostapd.conf be 
used so that it can 'understand' the marked traffic that arrives at the AP?

Please, any help?


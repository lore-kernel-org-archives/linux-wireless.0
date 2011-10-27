Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.3]:51593 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000Ab1J0JqJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 05:46:09 -0400
Received: from localhost (smtp-filter.ukfsn.org [192.168.54.205])
	by mail.ukfsn.org (Postfix) with ESMTP id 9A89CDEB9A
	for <linux-wireless@vger.kernel.org>; Thu, 27 Oct 2011 10:46:06 +0100 (BST)
Received: from mail.ukfsn.org ([192.168.54.25])
	by localhost (smtp-filter.ukfsn.org [192.168.54.205]) (amavisd-new, port 10024)
	with ESMTP id KTKmOffw5QDc for <linux-wireless@vger.kernel.org>;
	Thu, 27 Oct 2011 11:01:57 +0100 (BST)
Received: from stargate.localnet (unknown [84.45.236.142])
	by mail.ukfsn.org (Postfix) with ESMTP id 58A70DEB67
	for <linux-wireless@vger.kernel.org>; Thu, 27 Oct 2011 10:46:06 +0100 (BST)
From: David Goodenough <david.goodenough@btconnect.com>
To: linux-wireless@vger.kernel.org
Subject: does the creation of a mesh interface trigger a udev event?
Date: Thu, 27 Oct 2011 10:46:04 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201110271046.04592.david.goodenough@btconnect.com> (sfid-20111027_114614_749347_35689F19)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I create a mesh interface:-

iw dev wlan0 interface add mesh0 type mp ...

does a device creation event appear through udev?  Similarly while
the creation of wlan0 for a wireless card does create such an event,
do the monitor interfaces and phy's also create such events?

As far as I can see they do not, but I may be wrong - I may just be
listening for them wrongly.  If they do, any clues as to how to spot
them?

I ask for two reasons:-

1) It would seem consistent if they did.

2) For a configuration system like the one Debian uses, it is those
events that cause configuration to happen and so it would be easier 
to configure things like a mesh network if the events occur.

David

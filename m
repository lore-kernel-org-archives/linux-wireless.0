Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3547 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828Ab2JJVYR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 17:24:17 -0400
Message-ID: <5075E771.2090101@broadcom.com> (sfid-20121010_232420_330462_33F7E634)
Date: Wed, 10 Oct 2012 23:24:01 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: p2p question
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Reading the comment on .add_virtual_intf() callback I am a bit confused.

=====
  * @add_virtual_intf: create a new virtual interface with the given name,
  *	must set the struct wireless_dev's iftype. Beware: You must create
  *	the new netdev in the wiphy's network namespace! Returns the struct
  *	wireless_dev, or an ERR_PTR. For P2P device wdevs, the driver must
  *	also set the address member in the wdev.
=====

The last sentence refers to the "address member in wdev", but at least 
in my tree struct wireless_dev does not have an address member. Missing 
something here?

Gr. AvS


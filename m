Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [125.166.123.57] ([125.166.123.57]:52978 "EHLO Someone"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752183AbZJMMCb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 08:02:31 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by Someone (Postfix) with ESMTPS id BB6B81A42DA
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2009 01:53:08 +0700 (WIT)
Message-ID: <4AD4CC94.1030407@infi-nity.com>
Date: Wed, 14 Oct 2009 01:53:08 +0700
From: Pramono Tunggul <Pramono.tunggul@infi-nity.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Error Installing 'iw'
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Guyz, when I try to start airmon-ng, it said that I have to install iw,
so I download and install iw but I have never succeed to install iw,

PACKAGE_CONFIG_PATH=/usr/lib
export PACKAGE_CONFIG_PATH

make

CC iw.o
In file included from /usr/local/include/netlink/netlink.h:23,
from /usr/include/netlink/genl/genl.h:15,
from iw.c:17:
/usr/local/include/netlink/netlink-kernel.h:222: error: expected 
specifier-qualifier-list before ‘__u32’
/usr/local/include/netlink/netlink-kernel.h:232: error: expected 
specifier-qualifier-list before ‘__u16’
In file included from /usr/local/include/netlink/netlink.h:24,
from /usr/include/netlink/genl/genl.h:15,
from iw.c:17:
/usr/local/include/netlink/rtnetlink-kernel.h:281: error: expected 
specifier-qualifier-list before ‘__u32’
/usr/local/include/netlink/rtnetlink-kernel.h:342: error: expected 
specifier-qualifier-list before ‘__u8’
/usr/local/include/netlink/rtnetlink-kernel.h:403: error: expected 
specifier-qualifier-list before ‘__u32’
/usr/local/include/netlink/rtnetlink-kernel.h:431: error: expected 
specifier-qualifier-list before ‘__u16’
/usr/local/include/netlink/rtnetlink-kernel.h:477: error: expected 
specifier-qualifier-list before ‘__u32’
/usr/local/include/netlink/rtnetlink-kernel.h:498: error: expected 
specifier-qualifier-list before ‘__u64’
/usr/local/include/netlink/rtnetlink-kernel.h:533: error: expected 
specifier-qualifier-list before ‘__u8’
/usr/local/include/netlink/rtnetlink-kernel.h:540: error: expected 
specifier-qualifier-list before ‘__u16’
/usr/local/include/netlink/rtnetlink-kernel.h:622: error: expected 
specifier-qualifier-list before ‘__u32’
/usr/local/include/netlink/rtnetlink-kernel.h:629: error: expected 
specifier-qualifier-list before ‘__u32’
/usr/local/include/netlink/rtnetlink-kernel.h:663: error: expected 
specifier-qualifier-list before ‘__u64’
/usr/local/include/netlink/rtnetlink-kernel.h:751: error: expected 
specifier-qualifier-list before ‘__u32’
/usr/local/include/netlink/rtnetlink-kernel.h:767: error: expected 
specifier-qualifier-list before ‘__u32’
iw.c: In function ‘error_handler’:
iw.c:237: error: ‘NL_STOP’ undeclared (first use in this function)
iw.c:237: error: (Each undeclared identifier is reported only once
iw.c:237: error: for each function it appears in.)
iw.c: In function ‘ack_handler’:
iw.c:251: error: ‘NL_STOP’ undeclared (first use in this function)
iw.c: In function ‘__handle_cmd’:
iw.c:367: error: implicit declaration of function ‘nlmsg_alloc’
iw.c:367: warning: assignment makes pointer from integer without a cast
iw.c:373: error: implicit declaration of function ‘nl_cb_alloc’
iw.c:373: warning: assignment makes pointer from integer without a cast
iw.c:411: error: implicit declaration of function ‘nl_cb_put’
make: *** [iw.o] Error 1

Would you mind telling me how to install iw??

Thank you


Regards,

Pramono Tunggul

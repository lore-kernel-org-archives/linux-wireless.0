Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51538 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbYLINbH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 08:31:07 -0500
Subject: Re: wireless drivers sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: elmer@ylenurme.ee, "Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1228823435.22164.216.camel@johannes.berg> (sfid-20081209_125136_394228_BC992C34)
References: <1228823435.22164.216.camel@johannes.berg>
	 (sfid-20081209_125136_394228_BC992C34)
Content-Type: text/plain
Date: Tue, 09 Dec 2008 14:30:27 +0100
Message-Id: <1228829427.22164.227.camel@johannes.berg> (sfid-20081209_143117_819563_C4F6729B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And some from older drivers:

drivers/net/wireless/prism54/isl_ioctl.c:2053:20: warning: incorrect type in assignment (different address spaces)
drivers/net/wireless/prism54/isl_ioctl.c:2053:20:    expected void [noderef] <asn:1>*pointer
drivers/net/wireless/prism54/isl_ioctl.c:2053:20:    got char *[assigned] memptr
drivers/net/wireless/prism54/isl_ioctl.c:2072:20: warning: incorrect type in assignment (different address spaces)
drivers/net/wireless/prism54/isl_ioctl.c:2072:20:    expected void [noderef] <asn:1>*pointer
drivers/net/wireless/prism54/isl_ioctl.c:2072:20:    got char *[assigned] memptr
drivers/net/wireless/prism54/isl_ioctl.c:3001:25: warning: incorrect type in argument 2 (different signedness)
drivers/net/wireless/prism54/isl_ioctl.c:3001:25:    expected int enum oid_num_t *<noident>
drivers/net/wireless/prism54/isl_ioctl.c:3001:25:    got unsigned int *<noident>
drivers/net/wireless/prism54/oid_mgt.c:712:35: warning: incorrect type in argument 2 (different signedness)
drivers/net/wireless/prism54/oid_mgt.c:712:35:    expected int enum oid_num_t *l
drivers/net/wireless/prism54/oid_mgt.c:712:35:    got unsigned int *<noident>

drivers/net/wireless/arlan-main.c:969:48: warning: incorrect type in initializer (different address spaces)
drivers/net/wireless/arlan-main.c:969:48:    expected struct arlan_shmem volatile [noderef] <asn:2>*arlan
drivers/net/wireless/arlan-main.c:969:48:    got struct arlan_shmem *<noident>
drivers/net/wireless/arlan-main.c:1088:11: warning: incorrect type in assignment (different address spaces)
drivers/net/wireless/arlan-main.c:1088:11:    expected struct arlan_shmem [noderef] <asn:2>*card
drivers/net/wireless/arlan-main.c:1088:11:    got void *<noident>
drivers/net/wireless/arlan-main.c:1776:19: warning: symbol 'arlan_probe' was not declared. Should it be static?



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52061 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932890AbcATOCZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 09:02:25 -0500
Message-ID: <1453298541.13263.10.camel@sipsolutions.net> (sfid-20160120_150228_482905_66867511)
Subject: Re: [RFC V2 2/3] nl80211: add bss selection attribute to CONNECT
 command
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ilan Peer <ilan.peer@intel.com>
Date: Wed, 20 Jan 2016 15:02:21 +0100
In-Reply-To: <569EB9A6.4030808@broadcom.com>
References: <1452678583-20086-1-git-send-email-arend@broadcom.com>
	 <1452678583-20086-3-git-send-email-arend@broadcom.com>
	 <1452769832.2444.14.camel@sipsolutions.net> <569CB190.1000901@broadcom.com>
	 <1453209647.3896.22.camel@sipsolutions.net> <569EB9A6.4030808@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ilan pointed me to this:

http://androidxref.com/6.0.1_r10/xref/hardware/libhardware_legacy/include/hardware_legacy/gscan.h#351


I'd say that would just be a separate primitive, and then Android would
pick that in some way?

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([188.94.250.25]:61102 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab0JDHGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 03:06:16 -0400
From: Holger Schurig <holgerschurig@gmail.com>
To: Jochen Friedrich <jochen@scram.de>, linux-wireless@vger.kernel.org
Subject: Re: [Patch] iw: Implement set 4addr.
Date: Mon, 4 Oct 2010 09:15:58 +0200
References: <1286041239-19169-1-git-send-email-jochen@scram.de>
In-Reply-To: <1286041239-19169-1-git-send-email-jochen@scram.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010040915.58549.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +	"Set interface 4addr (WDS) mode.\n");

Hi Jochen !

Do you know if this feature can also be used to operate an Ethernet-Bridge on 
on a WLAN client?

I'd like to get something like this going, with eth0|wlan0 as a bridge, so 
that any protocol/port on the "DEVICE" is reachable from the network:

+--------+   +------------+   +----+   +---------+
| DEVICE +---+ eth0|wlan0 +---+ AP +---+ network |
+--------+   +------------+   +----+   +---------+
               Linux 2.6.x       
               w/ mac80211

-- 
Homepage: http://www.holgerschurig.de

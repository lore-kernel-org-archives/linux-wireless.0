Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:30425 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441AbaEPXEc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2014 19:04:32 -0400
From: "Park, Kyeyoon" <kyeyoonp@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC] cfg80211/mac80211: Add support for Proxy ARP
Date: Fri, 16 May 2014 23:04:56 +0000
Message-ID: <E3DE377D7E4999489B304A8FF33FC0D103A211C0@nasanexd01g.na.qualcomm.com> (sfid-20140517_010435_724114_C25F56E4)
References: <1400180784-26008-1-git-send-email-kyeyoonp@qca.qualcomm.com>
 <53751630.2030501@candelatech.com>
In-Reply-To: <53751630.2030501@candelatech.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

> > +#define STA_IPV4_HASH_SIZE 32
> > +#define STA_IPV4_HASH(ipv4) (((u8 *)&ipv4)[3] & 0x1F)
> 
> This should be a better hash I think.  Use an existing hash
> method or at least mix in the higher bits manually?

I assume that there is an existing IP address hash function
somewhere in the TCP/IP stack. I have a hard time finding
an externally available API that does this for me. Could you
point me to it?

Thanks!

Kyeyoon

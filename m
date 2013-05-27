Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53557 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab3E0T1v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 15:27:51 -0400
Message-ID: <1369682866.14740.30.camel@jlt4.sipsolutions.net> (sfid-20130527_212754_980579_3E154779)
Subject: Re: P2P Device support: how to deal with p2p_no_group_iface option
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Jouni Malinen <j@w1.fi>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jithu Jance <jithu@broadcom.com>,
	Marcel Holtmann <marcel@holtmann.org>
Date: Mon, 27 May 2013 21:27:46 +0200
In-Reply-To: <51A3B1F5.4070507@broadcom.com>
References: <51A09F43.5030004@broadcom.com>
	 <1369645418.8229.17.camel@jlt4.sipsolutions.net>
	 <51A36603.7020403@broadcom.com> <20130527181112.GA20210@w1.fi>
	 <1369682153.14740.27.camel@jlt4.sipsolutions.net>
	 <51A3B1F5.4070507@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-05-27 at 21:20 +0200, Arend van Spriel wrote:

> Marcel suggested a different approach that sounds pretty compelling from 
> a test perspective. However, that does change mac80211_hwsim behaviour 
> more significantly. No pain, no gain :-)

Yeah, he's suggested it before, and it'd be a good thing to have.
Luckily this is a test tool so I don't think anyone would mind changing
the module parameters too much. Hopefully.

johannes


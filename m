Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51405.mail.re2.yahoo.com ([206.190.38.184]:27663 "HELO
	web51405.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750758AbZK3Ijb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 03:39:31 -0500
Message-ID: <559043.79161.qm@web51405.mail.re2.yahoo.com>
Date: Mon, 30 Nov 2009 00:39:37 -0800 (PST)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: [RFC] API for setting ACK timeout
To: nbd@openwrt.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> At some point, I will try to come up with an implementation for 
> ath9k which doesn't involve such voodoo, but instead compares 
> the tx timestamp of some data packets against the rx timestamp 
> of ack packets. 

Would this mean, that we could get per station ACK timeouts?
If so, this would be very useful in an IBSS network. In such an
environment one might talk to nodes whose distance to the sender
vary over a broad range. 
-- 
Regards 
Joerg 

__________________________________________________
Do You Yahoo!?
Sie sind Spam leid? Yahoo! Mail verfügt über einen herausragenden Schutz gegen Massenmails. 
http://mail.yahoo.com 

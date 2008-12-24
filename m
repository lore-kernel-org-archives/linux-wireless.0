Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:50044 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbYLXRh3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 12:37:29 -0500
Message-ID: <20081224123749.k95tqs3hckgsogsk-cebfxv@webmail.spamcop.net> (sfid-20081224_183753_985710_19D026A2)
Date: Wed, 24 Dec 2008 12:37:49 -0500
From: Pavel Roskin <proski@gnu.org>
To: Fabio Rossi <rossi.f@inwind.it>
Cc: linux-wireless@vger.kernel.org
Subject: Re: p54: ad-hoc mode doesn't work
References: <200812230132.21839.rossi.f@inwind.it>
	<1230072758.5692.2.camel@dv> <200812241828.49679.rossi.f@inwind.it>
In-Reply-To: <200812241828.49679.rossi.f@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Fabio Rossi <rossi.f@inwind.it>:

> It seems strange to me, on the other PC I'm using the ath5k driver with a PCI
> wireless NIC and the interface enters in ad-hoc mode without complaining
> (CRDA is not installed).

Maybe you have CONFIG_WIRELESS_OLD_REGULATORY enabled on the systems  
with ath5k.

-- 
Regards,
Pavel Roskin

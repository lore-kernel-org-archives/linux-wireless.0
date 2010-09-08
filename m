Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:56046 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756085Ab0IHK71 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 06:59:27 -0400
Message-ID: <20100908065926.6wrt16onsckcocsk-cebfxv@webmail.spamcop.net>
Date: Wed, 08 Sep 2010 06:59:26 -0400
From: Pavel Roskin <proski@gnu.org>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rt61pci: oops in rt2x00lib_txdone(), entry->skb is NULL
References: <1283902212.5071.11.camel@mj>
	<201009080850.22338.helmut.schaa@googlemail.com>
	<AANLkTimFYCKGe2v9JF-aBozoKvHnUDw6B6Uj2K6rAwKk@mail.gmail.com>
In-Reply-To: <AANLkTimFYCKGe2v9JF-aBozoKvHnUDw6B6Uj2K6rAwKk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Ivo Van Doorn <ivdoorn@gmail.com>:

> Nice catch, this is indeed an obvious bug :S

The patch is working for me.  Thanks!

-- 
Regards,
Pavel Roskin

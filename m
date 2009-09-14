Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:40991 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356AbZINMcy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 08:32:54 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Igor Perminov <igor.perminov@inbox.ru>
Subject: Re: A station can't reconnect after it wakes up
Date: Mon, 14 Sep 2009 14:31:30 +0200
Cc: Kalle Valo <kalle.valo@iki.fi>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, hostap@lists.shmoo.com,
	Jouni Malinen <j@w1.fi>, Artur Skawina <art.08.09@gmail.com>
References: <1248969930.29068.224.camel@sunlight> <87my4z0w53.fsf@litku.valot.fi> <1252927472.26765.202.camel@sunlight>
In-Reply-To: <1252927472.26765.202.camel@sunlight>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200909141431.31091.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 4. The STA device wakes up and begins 
> authentication with an Auth frame as it hasn't been
> authenticated/associated previously.

What's the status of the PS bit of this Auth Frame?

Does the station here send a NULL func packet with the "I'm under 
power again" bit?   It might be necessary to do this via a 
null-func packet towards some broken APs.

-- 
http://www.holgerschurig.de

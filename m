Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60282 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab0JYIwn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 04:52:43 -0400
Subject: Re: Modifying the driver iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: "Cassiano Tartari, Eng." <falecom@cassianotartari.eng.br>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTinP32=snam3Bex+OC8LL00awfjrJz4834mhOaNL@mail.gmail.com>
References: <AANLkTinP32=snam3Bex+OC8LL00awfjrJz4834mhOaNL@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Oct 2010 10:39:27 +0200
Message-ID: <1287995967.3587.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-21 at 14:17 -0200, Cassiano Tartari, Eng. wrote:
> Its basic idea is that a client doesn't wait each
> response to go to the next step, so just do: AUTH REQ -> ASSOC REQ ->
> DHCP DISC -> DHCP REQ -> ARP QUERY and a PING THROUGH to verify that
> an end-to-end connection is available.

I'd just like to point out that for various reasons (that I invite you
to research for yourself) there's no way this can work in encrypted
networks, or against compliant/certified access points.

johannes


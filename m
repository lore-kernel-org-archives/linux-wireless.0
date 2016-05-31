Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40391 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757053AbcEaJmm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 05:42:42 -0400
Message-ID: <1464687759.3076.2.camel@sipsolutions.net> (sfid-20160531_114245_859652_B7166348)
Subject: Re: [PATCH] iw: add vendor command response support
From: Johannes Berg <johannes@sipsolutions.net>
To: Erik Stromdahl <erik.stromdahl@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 31 May 2016 11:42:39 +0200
In-Reply-To: <1462218930-6300-1-git-send-email-erik.stromdahl@gmail.com> (sfid-20160502_215537_638667_1DA34076)
References: <1462218930-6300-1-git-send-email-erik.stromdahl@gmail.com>
	 (sfid-20160502_215537_638667_1DA34076)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-05-02 at 21:55 +0200, Erik Stromdahl wrote:
> Introduced two new commands for reading vendor command responses:
> recv and recvbin
> Both will send a vendor command (typically some kind of GET request)
> in the same way as the current send command and print the received
> response in ASCII or binary.
> 
The bin thing seems a bit strange, but I can live with that :)

Applied.

johannes

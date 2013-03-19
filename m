Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40135 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933817Ab3CSUWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 16:22:47 -0400
Message-ID: <1363724562.8336.19.camel@jlt4.sipsolutions.net> (sfid-20130319_212256_083739_8F059B47)
Subject: Re: question on beacon-loss messages
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 19 Mar 2013 21:22:42 +0100
In-Reply-To: <5140FADF.9060307@candelatech.com> (sfid-20130313_232505_542751_F9862093)
References: <5140FADF.9060307@candelatech.com>
	 (sfid-20130313_232505_542751_F9862093)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-03-13 at 15:17 -0700, Ben Greear wrote:
> I am wondering, should the rssi_notify() call only be made if 'beacon' is
> true?

Yes, it does seem so.

johannes


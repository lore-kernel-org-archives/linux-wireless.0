Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39657 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab2GJTIx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 15:08:53 -0400
Message-ID: <1341947332.4475.32.camel@jlt3.sipsolutions.net> (sfid-20120710_210857_038670_DB41BC3A)
Subject: Re: Can one program see another's scan-results?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 10 Jul 2012 21:08:52 +0200
In-Reply-To: <4FFC7C4F.9020804@candelatech.com> (sfid-20120710_210252_194820_A6A69A50)
References: <4FFC7C4F.9020804@candelatech.com>
	 (sfid-20120710_210252_194820_A6A69A50)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-10 at 12:02 -0700, Ben Greear wrote:
> Is there a way to open a netlink socket and have it receive
> all scan results (even those requested by other applications)?

What do you mean by scan results? The results themselves? No, they are a
dump and unicast to one application. The fact that a scan finished? Yes,
of course.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038Ab2BKX3V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Feb 2012 18:29:21 -0500
Message-ID: <1329003047.14833.3.camel@dcbw.foobar.com> (sfid-20120212_002924_136707_0B3C21CC)
Subject: Re: Inter ProWireless 2915ABG
From: Dan Williams <dcbw@redhat.com>
To: Ramon Mendoza <rjmendoz@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 11 Feb 2012 17:30:47 -0600
In-Reply-To: <84DB9CD6-8B94-47F2-A359-3A9C949F87C1@gmail.com>
References: <84DB9CD6-8B94-47F2-A359-3A9C949F87C1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-02-11 at 08:26 -0800, Ramon Mendoza wrote:
> Where can I find driver or rpm for this device? i'm running RHEL 6.2 32bit.

If you're running RHEL, that card is driven by the 'ipw2200' driver and
is included in the RHEL kernel RPM already.

Dan



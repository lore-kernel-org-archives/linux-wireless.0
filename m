Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43556 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbYIPJKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 05:10:13 -0400
Message-ID: <b2d017be9e6908538faef3d96845500c.squirrel@secure.sipsolutions.net>
In-Reply-To: <877i9czdjd.fsf@nokia.com>
References: <200809151416.07552.hschaa@suse.de>
    <200809151429.46638.hschaa@suse.de>
    <1221494383.3700.52.camel@johannes.berg>
    <200809151835.03786.hschaa@suse.de> <877i9czdjd.fsf@nokia.com>
Date: Tue, 16 Sep 2008 11:10:10 +0200 (CEST)
Subject: Re: [RFC] Implement basic background scanning
From: "Johannes Berg" <johannes@sipsolutions.net>
To: "Kalle Valo" <kalle.valo@nokia.com>
Cc: "Helmut Schaa" <hschaa@suse.de>, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> Helmut Schaa <hschaa@suse.de> writes:
>
>>> This doesn't play well at all with hardware assisted scan as far as I
>>> can tell.
>>
>> Correct. The patch only adapts software scan code. The hardware
>> assisted scan is not touched at all but should also not be affected
>> in an odd way.
>
> I would guess that some firmwares support similar scanning in
> hardware. In the future we might add support for background scanning
> in hardware with a flag in hw_scan(), or something like that.

I don't want to see this implemented without taking into account hw scan
offload from the start.

johannes

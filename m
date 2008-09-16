Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:33556 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbYIPIoh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 04:44:37 -0400
To: "Helmut Schaa" <hschaa@suse.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] Implement basic background scanning
References: <200809151416.07552.hschaa@suse.de>
	<200809151429.46638.hschaa@suse.de>
	<1221494383.3700.52.camel@johannes.berg>
	<200809151835.03786.hschaa@suse.de>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 16 Sep 2008 11:43:34 +0300
In-Reply-To: <200809151835.03786.hschaa@suse.de> (ext Helmut Schaa's message of "Mon\, 15 Sep 2008 18\:35\:03 +0200")
Message-ID: <877i9czdjd.fsf@nokia.com> (sfid-20080916_104440_392853_D19C3FC7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa <hschaa@suse.de> writes:

>> This doesn't play well at all with hardware assisted scan as far as I
>> can tell.
>
> Correct. The patch only adapts software scan code. The hardware
> assisted scan is not touched at all but should also not be affected
> in an odd way.

I would guess that some firmwares support similar scanning in
hardware. In the future we might add support for background scanning
in hardware with a flag in hw_scan(), or something like that.

-- 
Kalle Valo

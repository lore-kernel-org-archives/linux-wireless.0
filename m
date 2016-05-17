Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37946 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbcEQGe6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2016 02:34:58 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Craig McQueen <craig.mcqueen@innerrange.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: rt2800 maximum clients in access point mode
References: <5500469A22567C4BAF673A6E86AFA3A4022D20D2594E@IR-CENTRAL.corp.innerrange.com>
Date: Tue, 17 May 2016 09:34:52 +0300
In-Reply-To: <5500469A22567C4BAF673A6E86AFA3A4022D20D2594E@IR-CENTRAL.corp.innerrange.com>
	(Craig McQueen's message of "Tue, 17 May 2016 15:10:02 +1000")
Message-ID: <878tz9p4z7.fsf@purkki.adurom.net> (sfid-20160517_083502_245563_248FFBB8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Craig McQueen <craig.mcqueen@innerrange.com> writes:

> What is the maximum number of clients that an rt2800 device can
> support simultaneously while in access point mode?
>
> I've had a look through the Linux kernel code and searched online, but
> haven't been able to find an answer so far.

If you find the answer, please submit a patch to set
wiphy->max_ap_assoc_sta in the driver. That way the limit is clearly
visible and hostapd can make use of it.

-- 
Kalle Valo

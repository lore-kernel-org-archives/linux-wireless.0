Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:57068 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbaFCKwG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2014 06:52:06 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] rsi: Adding support for bgscan, 5GHz support and clean up of code
References: <538C910E.6090703@redpinesignals.com>
Date: Tue, 03 Jun 2014 13:52:03 +0300
In-Reply-To: <538C910E.6090703@redpinesignals.com> (Jahnavi Meher's message of
	"Mon, 02 Jun 2014 20:28:22 +0530")
Message-ID: <87lhte1d0s.fsf@purkki.adurom.net> (sfid-20140603_125210_370619_9C37B8FB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jahnavi Meher <jahnavi.meher@redpinesignals.com> writes:

> From: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
>
> This patch adds code for support of bgscan and 5GHz. It also contains
> changes to the piece of code that determines the number of packets to 
> be de-queued from soft queues - it is changed from a fixed number to
> a count based on txop. There are also a number of small clean ups.
>
> Signed-off-by: Jahnavi Meher <jahnavi.meher@redpinesignals.com>

Patches should always contain one logical change per patch. This patch
adds three new features plus small clean ups, that's too much. For
example, you could split the patches like this:

1. add 5 GHz
2. add bgscan
3. queue change
4. small cleanups (one or more patches depending on the changes)

-- 
Kalle Valo

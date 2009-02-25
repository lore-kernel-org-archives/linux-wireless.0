Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:33739 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762678AbZBYVaa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2009 16:30:30 -0500
Cc: Lorenzo Nava <navalorenx@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
Message-Id: <7B2FC6CE-4169-480A-B5D5-5CC7CECACEF4@ing.unibs.it> (sfid-20090225_223039_105027_ACB09829)
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
To: Larry Finger <larry.finger@lwfinger.net>
In-Reply-To: <49A56B1F.80702@lwfinger.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: Latest test  with open-source firmware
Date: Wed, 25 Feb 2009 22:30:23 +0100
References: <49A56B1F.80702@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 25, 2009, at 5:00 PM, Larry Finger wrote:

> Francesco and Lorenzo,
>
> In my latest test, I cut the RX and TX queue depths to 32 and ran my  
> usual
> stress test. This time I logged whenever there was an increase in  
> the depth of
> the txstatus queue, and whenever the queue depth was 16. The results  
> were as
> follows:
>
> Feb 24 19:27:08 mtech kernel: b43: Max Queue depth is now 2
> Feb 24 19:27:12 mtech kernel: b43: Max Queue depth is now 3
> Feb 24 19:27:12 mtech kernel: b43: Max Queue depth is now 4
> Feb 24 19:27:12 mtech kernel: b43: Max Queue depth is now 5
> Feb 24 19:27:12 mtech kernel: b43: Max Queue depth is now 6
> Feb 24 19:27:12 mtech kernel: b43: Max Queue depth is now 7
> Feb 24 19:27:12 mtech kernel: b43: Max Queue depth is now 8
> Feb 24 19:27:12 mtech kernel: b43: Max Queue depth is now 9
> Feb 24 19:27:12 mtech kernel: b43: Max Queue depth is now 10
> Feb 24 19:28:46 mtech kernel: b43: Max Queue depth is now 11
> Feb 25 00:07:19 mtech kernel: b43: Max Queue depth is now 12
> Feb 25 00:07:19 mtech kernel: b43: Max Queue depth is now 13
> Feb 25 00:09:12 mtech kernel: b43: Max Queue depth is now 14
> Feb 25 00:09:50 mtech kernel: b43: Max Queue depth is now 15
> Feb 25 00:09:50 mtech kernel: b43: Max Queue depth is now 16
> Feb 25 00:09:50 mtech kernel: b43: Max queue depth at 16
> Feb 25 00:09:54 mtech kernel: b43: Max queue depth at 16
> Feb 25 00:10:55 mtech kernel: b43: Max queue depth at 16
> Feb 25 00:26:24 mtech kernel: eth1: No ProbeResp from current AP
> 00:1a:70:46:ba:b1 - assume out of range
>
> The 00:26:24 event was the interface going offline. That happens with
> proprietary firmware, thus I think that problem is with the driver,  
> rather than
> the firmware. In any case, I got no out-of-order cookies or poisoned  
> skb's.
> There were no dropped packets nor PHY transmission errors. The above  
> list is all
> the b43 messages in the log.
Larry, (pardon me if you answered this question) have you tried to see  
what happens with the halved queue when using the open firmware?

Cheers,
-FG

> I have reset the RX queue depth to the original value of 64 and have  
> started
> another test. I would expect this change to have no effect, but I'll  
> keep you
> informed.
>
> Larry

-------

Francesco Gringoli, PhD - Assistant Professor
Dept. of Electrical Engineering for Automation
University of Brescia
via Branze, 38
25123 Brescia
ITALY

Ph:  ++39.030.3715843
FAX: ++39.030.380014
WWW: http://www.ing.unibs.it/~gringoli





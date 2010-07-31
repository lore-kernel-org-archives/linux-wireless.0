Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14988 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999Ab0GaXIi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jul 2010 19:08:38 -0400
Message-ID: <4C54ACE7.1000205@linux.intel.com>
Date: Sun, 01 Aug 2010 01:08:23 +0200
From: Sebastien Cayetanot <sebastien.cayetanot@linux.intel.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Regulatory domain
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  All,

I have used the CRDA capability using the "iw" tool to set the country code.

When I use the 'iw reg get' command, the return below is diplayed.

country JP:
         (2402 - 2472 @ 40), (N/A, 20)
         (2457 - 2482 @ 20), (N/A, 20)
         (2474 - 2494 @ 20), (N/A, 20), NO-OFDM
         (4910 - 4930 @ 10), (N/A, 23)
         (4910 - 4990 @ 40), (N/A, 23)
         (4930 - 4950 @ 10), (N/A, 23)
         (5030 - 5045 @ 10), (N/A, 23)
         (5030 - 5090 @ 40), (N/A, 23)
         (5050 - 5060 @ 10), (N/A, 23)
         (5170 - 5250 @ 40), (N/A, 20)
         (5250 - 5330 @ 40), (N/A, 20), DFS
         (5490 - 5710 @ 40), (N/A, 23), DFS

I would like to understand exactly what is displayed.

- the number of line (xxx-xxx @ xx), (xx,xx) is equal to the number of 
channel which can be accessed
- What is the meaning of each line and details on each parameter.

Thx and regards


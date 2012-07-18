Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-3.exch022.serverdata.net ([206.225.164.186]:64277
	"EHLO HUB022-nj-3.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752650Ab2GRMck convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 08:32:40 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: 11ac 80Mhz Channel center freq
Date: Wed, 18 Jul 2012 12:32:39 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA0DA040@mbx022-e1-nj-10.exch022.domain.local> (sfid-20120718_143243_960539_D0AFE866)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

In 5GHz band, center freq are 5180, 5200, 5220, 5240...
So the allowed non-DFS spectrum for 80MHz operation is like 5170MHz to 5250MHz.
The center freq for 5170-5250 is 5210MHz.
If I specify my BSS channel with center freq as 5210MHz, its not falling in our channel list.
I want to find out the best way on what channel does 80Mhz channel width operation can be allowed.

Thanks,
Mahesh

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:47146 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbYLAP0k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 10:26:40 -0500
Subject: Re: 11d segfault
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1228129742.3478.2.camel@johannes.berg>
References: <1228129742.3478.2.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 16:26:35 +0100
Message-Id: <1228145195.31158.137.camel@violet.holtmann.net> (sfid-20081201_162644_495863_C3498999)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> Dec  1 12:07:00 johannes kernel: [  193.370168] Unable to handle kernel paging request for data at address 0x00000000
> Dec  1 12:07:00 johannes kernel: [  193.370180] Faulting instruction address: 0xf2794560
> Dec  1 12:07:00 johannes kernel: [  193.370194] Oops: Kernel access of bad area, sig: 11 [#1]

are you running kerneloops? If not, please do so :)

Regards

Marcel



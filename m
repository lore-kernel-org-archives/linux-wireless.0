Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:31372 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYLRBe5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 20:34:57 -0500
Received: by wa-out-1112.google.com with SMTP id v27so102698wah.21
        for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2008 17:34:56 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18761.43079.702658.733757@localhost.localdomain> (sfid-20081218_023505_825678_AA4AAF64)
Date: Thu, 18 Dec 2008 07:02:55 +0530
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	mcgrof@gmail.com, jouni.malinen@atheros.com
Subject: Re: [RFC] Handle Channel Switch Announcement
In-Reply-To: <20081217162017.GA28712@jm.kir.nu>
References: <18761.4838.509784.281821@localhost.localdomain>
	<20081217162017.GA28712@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen wrote:
> Why is this flag needed? Or well, the better question: Why is the
> channel disabled? CSA may request the STA to stop transmitting _within
> the BSS_ until the AP has changed channels (i.e., it could be possible
> to use other BSSes even on the same channel). This notification can be
> used for other things than just reporting a radar on the channel (e.g.,
> the AP could move to a channel that has less traffic on it).
> 

Ok, agreed. I'll remove this flag.

But after receiving a CSA on the current frequency, and having moved to the new
advertised frequency, can the STA send out probe requests in the earlier frequency ?
(In case of a scan run or something)

Sujith

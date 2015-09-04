Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:11785 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755281AbbIDKz6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2015 06:55:58 -0400
Message-ID: <55E978BB.1030009@neratec.com> (sfid-20150904_125602_042634_6BEEE15B)
Date: Fri, 04 Sep 2015 12:55:55 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Peter Oh <poh@codeaurora.org>, Peter Oh <poh@qca.qualcomm.com>,
	ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath: use PRI value given by spec for fixed PRI
References: <1427475590-2198-1-git-send-email-poh@qca.qualcomm.com> <55191D89.2000300@neratec.com> <55198EA4.1010101@codeaurora.org> <551BC2B1.3030002@neratec.com> <55E88BA4.7010009@codeaurora.org>
In-Reply-To: <55E88BA4.7010009@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/03/2015 08:04 PM, Peter Oh wrote:
> Hi Zefir,
> 
> I believe the patch below is good to be checked in since you've already made
> change in DFS.
> Can you confirm it?
> 
> [...]
> 
Hi Peter,

yes, after adding the chirp detecting feature to ath9k, I did an internal
certification run with all your patches applied. All good for ETSI (FCC testing
ongoing), so full ACK for the changes.


Cheers,
Zefir



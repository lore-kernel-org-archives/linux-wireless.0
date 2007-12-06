Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:2241 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbXLFKs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 05:48:57 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] wireless/libertas: don't cast a pointer to pointer of list_head
Date: Thu, 6 Dec 2007 11:49:18 +0100
Cc: Li Zefan <lizf@cn.fujitsu.com>, davem@davemloft.net,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <4757C773.5010604@cn.fujitsu.com>
In-Reply-To: <4757C773.5010604@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200712061149.18209.hs4233@mail.mn-solutions.de> (sfid-20071206_104903_015180_632642F8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> BTW: I'm not so sure where this patch should go to.

To <linux-wireless@vger.kernel.org>, as Dan Williams (libertas 
maintainer) monitors this list.

The wireless development tree is wireless-2.6, branch everything. 
You patch doesn't apply to this tree currently, but it's easy to 
fix. I'll bring it in shape, and resubmit.




As a side note: if you want to make comments, put them below --- 
under your Signed-off-by line. Your "BTW"-Line would have ended 
up in the output of "git log".



libertas: fixes blah mumpf worps

This fixes the worps feature.

Signed-of-by: Donald Duck <dduck@entenhausen.de>

---
Here you can put any comments about your patch that should not 
end up in the history of git that you can see with "git log".

[patch comes here]

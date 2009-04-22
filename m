Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:53536 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbZDVTxb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 15:53:31 -0400
Received: by mail-bw0-f163.google.com with SMTP id 7so163629bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 22 Apr 2009 12:53:31 -0700 (PDT)
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 6/6] wl12xx: update set_key callback to match current API
References: <1238897428-19639-1-git-send-email-me@bobcopeland.com>
	<1238897428-19639-7-git-send-email-me@bobcopeland.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 22 Apr 2009 22:53:28 +0300
In-Reply-To: <1238897428-19639-7-git-send-email-me@bobcopeland.com> (Bob Copeland's message of "Sat\,  4 Apr 2009 22\:10\:28 -0400")
Message-ID: <873ac0ea87.fsf@litku.valot.fi> (sfid-20090422_215333_678144_9B64A095)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> Use the new prototype for ops->set_key which now takes a vif pointer
> and sta pointer instead of a pair of addresses.  Remove the debug
> statement for local_addr since wl12xx_op_set_key doesn't use the vif
> pointer anyway.

Applied.

-- 
Kalle Valo

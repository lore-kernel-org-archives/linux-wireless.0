Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:36907 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZDVTy7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 15:54:59 -0400
Received: by bwz7 with SMTP id 7so164494bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 22 Apr 2009 12:54:57 -0700 (PDT)
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] wl12xx: remove sysfs file
References: <1240371860-9001-1-git-send-email-me@bobcopeland.com>
	<1240371860-9001-2-git-send-email-me@bobcopeland.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 22 Apr 2009 22:54:55 +0300
In-Reply-To: <1240371860-9001-2-git-send-email-me@bobcopeland.com> (Bob Copeland's message of "Tue\, 21 Apr 2009 23\:44\:19 -0400")
Message-ID: <87tz4gcvlc.fsf@litku.valot.fi> (sfid-20090422_215501_312627_4B8C34D8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> Remove tx_mgmt_frm_rate file since we don't need it.

I agree. I made this hack because our RF engineers needed, it shouldn't
be in upstream version.

-- 
Kalle Valo

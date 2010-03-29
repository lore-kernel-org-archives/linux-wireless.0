Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:51000 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab0C2Rli (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 13:41:38 -0400
Date: Mon, 29 Mar 2010 19:41:35 +0200
From: Ralph Benzinger <t1@endlos.net>
To: linux-wireless@vger.kernel.org
Subject: Re: Problems with hardware radio kill switch on Sony Vaio notebook
Message-ID: <20100329174135.GD6445@endlos.net>
References: <20100329152721.GC6445@endlos.net> <20100329170604.GC4984@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100329170604.GC4984@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On March 29, you wrote:
> Generally, sony-laptop would be responsible for correctly reporting
> the rfkill switch state.

John,

Thanks for the info, I appreciate it!

Just a naive follow-up question then: Wouldn't it be possible for the
ath9k driver to ignore the rfkill switch settings?  (Assuming, of
course, that there is no actual physical power disconnect, which I
doubt.)

Is there a simple way to override the rfkill effect on ath9k via
/proc or /sys?  Or alternatively, if I were to recompile the ath9k
module, what would I need to change/disable?  (On the other hand,
hacking sony-laptop seems to be the easier way.)

Any pointers would be greatly appreciated.

Regards
Ralph

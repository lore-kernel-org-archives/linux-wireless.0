Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51982 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab1DTUT5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 16:19:57 -0400
Date: Wed, 20 Apr 2011 17:20:15 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: pull request: bluetooth-2.6 2011-04-20
Message-ID: <20110420202015.GA2311@joana>
References: <20110420170432.GA2301@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110420170432.GA2301@joana>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

* Gustavo F. Padovan <padovan@profusion.mobi> [2011-04-20 14:04:32 -0300]:

> Hi John,
> 
> Four small fixes for 2.6.39. An incorrect refcnt balance for hci connection by
> Ville Tervo, a warning fix in the command timer by Vinicius Gomes, an ERTM
> fix by Ruiyi Zhang, and SCO synchronization fix by Luiz Augusto von Dentz.
> 
> Please pull or let me know any problems. Thanks.

Hold on with the pull! I've found a merge conflict with -next. (I tested the
merge with --dry-run, but it doesn't check for check conflicts). I'll do the
right thing now and send a new pull request to you soon. 

Regards,

-- 
Gustavo F. Padovan
http://profusion.mobi

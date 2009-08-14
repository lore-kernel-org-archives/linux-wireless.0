Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:63420 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754094AbZHNGJN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 02:09:13 -0400
Message-ID: <20090814020913.0h159bvuo0sccwcg-cebfxv@webmail.spamcop.net>
Date: Fri, 14 Aug 2009 02:09:13 -0400
From: Pavel Roskin <proski@gnu.org>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: Revert commit in ath9k
References: <19076.56592.101907.186453@gargle.gargle.HOWL>
In-Reply-To: <19076.56592.101907.186453@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Sujith <Sujith.Manoharan@atheros.com>:

> John,
>
> Can you revert the commit - "ath9k: Change DEBUG level for certain   
> interrupts" ?
> This interrupt seems to trigger fairly often and floods the log.

I think it would be better to revert only the part for the actually  
triggered AR_INTR_SYNC_LOCAL_TIMEOUT.  This way we'll learn of other  
unexpected interrupts if they happen for some users.

-- 
Regards,
Pavel Roskin

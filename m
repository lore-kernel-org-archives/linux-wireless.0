Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blaine.gmane.org ([80.91.229.8]:51435 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbZD3TP7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 15:15:59 -0400
Received: from public by hugh.gmane.org with local (Exim 4.63)
	(envelope-from <public@hugh.gmane.org>)
	id 1LzbNR-0008TH-1G
	for linux-wireless@vger.kernel.org; Thu, 30 Apr 2009 20:52:57 +0200
From: Andreas Schwab <schwab@linux-m68k.org>
To: reinette chatre
	<public-reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@hugh.gmane.org>
Cc: Andreas Schwab
	<public-schwab-Td1EMuHUCqxL1ZNQvxDV9g@hugh.gmane.org>,
	"linux-wireless-u79uwXL29TY76Z2rM5mHXA\@public.gmane.org"
	<public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA\@public.gmane.org"
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>
Subject: Re: iwlwifi: remove EXPORT_SYMBOL for static symbol
References: <m24ow6vah1.fsf@igel.home> <1241112119.10498.11.camel@rc-desk>
	<m24ow6xd9y.fsf@igel.home> <1241116390.10498.50.camel@rc-desk>
Date: Thu, 30 Apr 2009 20:33:23 +0200
In-Reply-To: <1241116390.10498.50.camel@rc-desk> (reinette chatre's message of
	"Thu, 30 Apr 2009 11:33:10 -0700")
Message-ID: <m2zldyvvnw.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



reinette chatre
<reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:

> Thanks. Even though this patch obsoletes
> 6269b731560d69c5eaa929909891edec39496d71 it still makes sense to have
> that patch in the repo as it removes another unnecessary EXPORT_SYMBOL.
> I would thus prefer that both patches are included.

I agree.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."


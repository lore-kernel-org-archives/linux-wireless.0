Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34658 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751793AbZLMInk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Dec 2009 03:43:40 -0500
Received: by ewy19 with SMTP id 19so2411452ewy.21
        for <linux-wireless@vger.kernel.org>; Sun, 13 Dec 2009 00:43:38 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/2] wireless: support internal statically compiled regulatory database
References: <1260654163-11214-1-git-send-email-linville@tuxdriver.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 13 Dec 2009 10:43:36 +0200
In-Reply-To: <1260654163-11214-1-git-send-email-linville@tuxdriver.com> (John W. Linville's message of "Sat\, 12 Dec 2009 16\:42\:42 -0500")
Message-ID: <87638b1cxz.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

> This patch provides infrastructure for machine translation of the
> regulatory rules database used by CRDA into a C data structure.
> It includes code for searching that database as an alternative
> to dynamic regulatory rules updates via CRDA.  Most people should
> use CRDA instead of this infrastructure, but it provides a better
> alternative than the WIRELESS_OLD_REGULATORY infrastructure (which
> can now be removed).

At least I can see uses of this, not everyone want to install crda.
For starters, debian unstable still doesn't have crda. And special
cases, for example products like n900, would benefit from this a lot.

-- 
Kalle Valo

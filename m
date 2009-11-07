Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:64487 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZKGKxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 05:53:49 -0500
Received: by ewy3 with SMTP id 3so1795254ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2009 02:53:54 -0800 (PST)
To: Bing Zhao <bzhao@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"libertas-dev\@lists.infradead.org"
	<libertas-dev@lists.infradead.org>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: Re: [PATCH] Libertas: Fix issues while configuring host sleep
References: <1257383195-951-1-git-send-email-bzhao@marvell.com>
	<20091106201924.GH2782@tuxdriver.com>
	<477F20668A386D41ADCC57781B1F704306E01F78F3@SC-VEXCH1.marvell.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 07 Nov 2009 12:53:51 +0200
In-Reply-To: <477F20668A386D41ADCC57781B1F704306E01F78F3@SC-VEXCH1.marvell.com> (Bing Zhao's message of "Fri\, 6 Nov 2009 13\:27\:50 -0800")
Message-ID: <87hbt6fvwg.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bing Zhao <bzhao@marvell.com> writes:

>> The reformatting is a distraction.  It would be better to do just
>> the fix part separately, especially if you are targetting 2.6.32.
>
> Without the reformatting, the change would be like this:
>
> +	if (wol->wolopts == 0)    criteria |= EHS_REMOVE_WAKEUP;
>
> But the "checkpatch.pl" script gave me an error on that:
> "ERROR: trailing statements should be on next line"

You can do the reformatting in the first patch and the second patch
would contain the actual fix.

-- 
Kalle Valo

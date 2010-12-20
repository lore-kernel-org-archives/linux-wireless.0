Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:62268 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932744Ab0LTTxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 14:53:05 -0500
Received: from [192.168.178.92] (p5B319A8D.dip0.t-ipconnect.de [91.49.154.141])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by v216570639.yourvserver.net (Postfix) with ESMTPSA id C70D2DFA942
	for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 20:53:01 +0100 (CET)
Message-ID: <4D0FB427.9090901@lophus.org>
Date: Mon, 20 Dec 2010 20:53:11 +0100
From: "Jonas H." <jonas@lophus.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: Recent suspend/resume fix for which devices?
References: <4D0E19EB.3070802@lophus.org> <20101220141531.GB10104@tuxdriver.com>
In-Reply-To: <20101220141531.GB10104@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/20/2010 03:15 PM, John W. Linville wrote:
>> My question is: Does that fix also apply to my card? I realize the
>> patch only applies to ath9k_htc but I couldn't figure what "htc"
>> stands for in this context.
>
> Probably not.  Did you try reverting it?

I didn't, because I dislike compilation on netbooks. ;)

>> If it doesn't, does this mailing list also function as a bug tracker?
>
> Sorta, but not really.  There is a bugzilla instance at bugzilla.kernel.org.

Thanks, filed a bug there: https://bugzilla.kernel.org/show_bug.cgi?id=25342

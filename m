Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:61477 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528AbZAOUG3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 15:06:29 -0500
Received: by nf-out-0910.google.com with SMTP id d3so202194nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2009 12:06:26 -0800 (PST)
Message-ID: <496F9740.5010109@gmail.com> (sfid-20090115_210644_876254_CB26DB06)
Date: Thu, 15 Jan 2009 21:06:24 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Artur Skawina <art.08.09@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
References: <494698AF.4020204@gmail.com> <200901151953.49053.chunkeey@web.de> <496F8A83.8000605@gmail.com> <200901152042.42372.chunkeey@web.de>
In-Reply-To: <200901152042.42372.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Thursday 15 January 2009 20:12:03 Artur Skawina wrote:
>>>> Upgraded to current wireless-testing/pending on the problematic box
>>>> and almost immediately got [1]. No slab corruption this time (at least
>>>> not yet). Will switch to GFP_ATOMIC and retry w/ the new fw.

>>> yes that's a bug, p54_set_tim must use GFP_ATOMIC, do you want to post the patch?
>> nah, too trivial :) fwiw i used this:
> well, it should be "done", right? :-)
> 
> just add "John W. Linville" <linville@tuxdriver.com>" to the cc,
> change the subject line to "[PATCH] p54: set_tim must be atomic."
> and put a Signed-off-by: your name <your@mail> in the mail body and a "---" to seperate the commit message
> and then the patch. And it will be in the next round of -rcX fixes.

well, i really meant the 'too trivial' part and was hoping you'd do it ;)
ok, will resend.

Is this something that could interfere w/ testing:
> mac80211-phy0: failed to remove key (0, 00:1b:fb:12:34:56) from hardware (-12)
?

thanks,

artur

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49384 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751243AbcKRLF1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 06:05:27 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: "Lazar\, Alexei Avshalom" <ailizaro@codeaurora.org>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: cfg80211: add set/get link loss profile
References: <7742335b-f05e-edcd-ad80-fd09fb295eab@codeaurora.org>
        <8737izqw0q.fsf@purkki.adurom.net>
        <b1ab1406-d996-fc03-d0a2-b8028c7c0044@codeaurora.org>
Date: Fri, 18 Nov 2016 13:05:21 +0200
In-Reply-To: <b1ab1406-d996-fc03-d0a2-b8028c7c0044@codeaurora.org> (Alexei
        Avshalom Lazar's message of "Thu, 17 Nov 2016 15:50:35 +0200")
Message-ID: <8737ipm4jy.fsf@kamboji.qca.qualcomm.com> (sfid-20161118_120531_381589_DB3DCAEB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alexei,

"Lazar, Alexei Avshalom" <ailizaro@codeaurora.org> writes:

> In this context the term "link" does mean connection to AP. There are
> scenarios that require to lose connection faster once reduced link
> quality detected in order maintain better user experience (from both
> sides - AP and STA). Example case is FST (Fast Session Transfer),
> where we have a fast 11ad connection but close-range and a backup 11ac
> connection which is "always on". in such cases if we detect poor link
> quality in the active band we prefer to disconnect and switch to the
> backup connection with the good link quality. This will be reached by
> setting "aggressive" profile that will cause more rapid disconnect in
> such cases.

The documentation should clearly document what this command is supposed,
currently it only tells me "maintain/lose link" and does not specify in
detail what this is supposed to do. Also there's no mention in what
modes this can be used. (STA, P2P?)

Also please refrain from top posting in public mailing lists, the
preferred way is to edit quotes and bottom post. It's much more natural
way to have long detailed discussions.

-- 
Kalle Valo

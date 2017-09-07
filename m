Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46662 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932097AbdIGMe5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Sep 2017 08:34:57 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: using vulnerability ids in patches
References: <7415a11b-398c-69df-b39f-7b985f07112b@broadcom.com>
Date: Thu, 07 Sep 2017 15:34:52 +0300
In-Reply-To: <7415a11b-398c-69df-b39f-7b985f07112b@broadcom.com> (Arend van
        Spriel's message of "Thu, 7 Sep 2017 10:40:41 +0200")
Message-ID: <87bmmmn0ur.fsf@kamboji.qca.qualcomm.com> (sfid-20170907_143629_985636_A34AA6D5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> Due to recent events we were asked about some vulnerability fixes for
> brcmfmac. We already fixed a couple of things without referring to a
> so-called CVE-ID, which is what people are asking for. Do we have a
> upstream policy on that? I could not really find anything in the
> Documentation folder (but I may have overlooked it). Might be worth
> mentioning in the commit message like with the coverity ids.

Johannes already answered, but I'll just add that this is all I know
about security patches:

  If you have a patch that fixes an exploitable security bug, send that
  patch to security@kernel.org. For severe bugs, a short embargo may be
  considered to allow distributors to get the patch out to users; in
  such cases, obviously, the patch should not be sent to any public
  lists.

  https://www.kernel.org/doc/html/latest/process/submitting-patches.html

I don't know if you should follow that in this case or not, just wanted
to point out this.

-- 
Kalle Valo

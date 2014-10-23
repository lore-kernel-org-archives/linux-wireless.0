Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:39144 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaJWNU3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 09:20:29 -0400
Received: by mail-wi0-f177.google.com with SMTP id ex7so1782445wid.16
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2014 06:20:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1413807758-30249-1-git-send-email-michal.kazior@tieto.com>
References: <1413807758-30249-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 23 Oct 2014 15:20:28 +0200
Message-ID: <CA+BoTQkrUQ6T60qztMuBbjy=vU-4Cho+yBXS051W=fNRTgNeig@mail.gmail.com> (sfid-20141023_152040_165032_3423039C)
Subject: Re: [PATCH v2 0/3] ath10k: speed up recovery
From: Michal Kazior <michal.kazior@tieto.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 October 2014 14:22, Michal Kazior <michal.kazior@tieto.com> wrote:
> Patch #1 fixes a bug I've found while testing
> patches #2 and #3. It's safe to cherry-pick it in
> case patches #2 and/or #3 aren't accepted or need
> a re-spin.
>
> I've mainly used patch #2 to test reset and
> recovery. It's pretty handy for (stress-)testing.
>
> Patch #3 should improve recovery speed in some
> cases. Notably when there's a long chain of WMI
> commands involved which take a painfully long time
> to timeout/complete if firmware crashes mid-way.
>
> Note: Patches #2 and #3 depend on `ath10k: pci
> related fixes 2014-10-09`. Without the patchset
> patches #2 and #3 must not be applied. Patch #1 is
> fine though.

Do not apply this patchset yet, please. I need to do a minor fix in
the 'ath10k: fix possible bmi crash' regarding warm reset patch from
the other patchset.


Michał

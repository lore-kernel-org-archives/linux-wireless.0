Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:54511 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3HZUUy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 16:20:54 -0400
Received: by mail-la0-f48.google.com with SMTP id er20so2757184lab.35
        for <linux-wireless@vger.kernel.org>; Mon, 26 Aug 2013 13:20:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1377507205-5386-1-git-send-email-michal.kazior@tieto.com>
References: <1377066854-13981-1-git-send-email-michal.kazior@tieto.com> <1377507205-5386-1-git-send-email-michal.kazior@tieto.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 26 Aug 2013 13:20:32 -0700
Message-ID: <CAB=NE6X=P2hTnOC8xqFwb=-32-hBgx=ndq3KHoUG83KptKv0vA@mail.gmail.com> (sfid-20130826_222100_206913_8016DA9A)
Subject: Re: [PATCH v2 0/4] ath10k: fixes
To: Michal Kazior <michal.kazior@tieto.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 26, 2013 at 1:53 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
>   ath10k: fix issues on non-preemptible systems

This patch looks like a stable candidate fix. Please annotate as such
if you confirm. Also, I reviewed other ath10k "fixes" and I see no
practice of propagating any patches to stable yet. Can you please
start doing that? If there were patches which are already merged
upstream that should be propagated to stable then they can be
submitted as stable candidate patches.

  Luis

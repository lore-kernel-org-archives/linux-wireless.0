Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:56489 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173AbbBLIpE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2015 03:45:04 -0500
Received: by mail-we0-f180.google.com with SMTP id k11so8500689wes.11
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2015 00:45:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1423224174-24764-3-git-send-email-michal.kazior@tieto.com>
References: <1423224174-24764-1-git-send-email-michal.kazior@tieto.com>
	<1423224174-24764-3-git-send-email-michal.kazior@tieto.com>
Date: Thu, 12 Feb 2015 09:45:02 +0100
Message-ID: <CA+BoTQkhSgeTibz3rTnuBQN+BEf-Kq-UHPCBav12ARE1xA5Feg@mail.gmail.com> (sfid-20150212_094509_646142_3D599169)
Subject: Re: [PATCH v3 2/7] ath10k: implement chanctx API
From: Michal Kazior <michal.kazior@tieto.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 February 2015 at 13:02, Michal Kazior <michal.kazior@tieto.com> wrote:
> The chanctx API will allow ath10k to support
> multi-channel operation.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
[...]

I'll post a v4 later including an AP CSA fix for an issue I've
introduced in v3. v4 will also make AP CSA work with qca6174.


Michał

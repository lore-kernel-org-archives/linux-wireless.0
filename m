Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54095 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab2HBRnn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 13:43:43 -0400
Received: by qcro28 with SMTP id o28so5577253qcr.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Aug 2012 10:43:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343888930-353-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1343888930-353-1-git-send-email-mohammed@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 2 Aug 2012 10:43:22 -0700
Message-ID: <CAB=NE6WYGefu8vYrO05tq=5qnCcMqWtUQkTzisR2sfpTLMx8WQ@mail.gmail.com> (sfid-20120802_194346_348948_7D3AD620)
Subject: Re: [PATCH] ath9k: Add PID/VID support for AR1111
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Felix Bitterli <felixb@qca.qualcomm.com>,
	Tim and Alison Bentley <Home@trarbentley.net>,
	Dan Williams <dcbw@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 1, 2012 at 11:28 PM, Mohammed Shafi Shajakhan
<mohammed@qca.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>
> AR1111 is same as AR9485. The h/w
> difference between them is quite insignificant,
> Felix suggests only very few baseband features
> may not be available in AR1111. The h/w code for
> AR9485 is already present, so AR1111 should
> work fine with the addition of its PID/VID.
>
> Cc: stable@vger.kernel.org [2.6.39+]
> Cc: Felix Bitterli <felixb@qca.qualcomm.com>
> Reported-by: Tim and Alison Bentley <Home@trarbentley.net>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Nice! I'd be happy with this going in once we get a Tested-by: report. Dan, Tim?

 Luis

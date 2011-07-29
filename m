Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62111 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab1G2VdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 17:33:25 -0400
Received: by qwk3 with SMTP id 3so2033009qwk.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jul 2011 14:33:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1311973269-24489-1-git-send-email-lrodriguez@qca.qualcomm.com>
References: <1311973269-24489-1-git-send-email-lrodriguez@qca.qualcomm.com>
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Date: Fri, 29 Jul 2011 14:33:04 -0700
Message-ID: <CAB=NE6WM41KjjbUjq-UigKSV6+YeQ-syYcwSV1Gxm-_+XiOx0A@mail.gmail.com> (sfid-20110729_233328_262902_6DFDDE3A)
Subject: Re: [PATCH v7 4/4] hostapd: add Automatic Channel Selection (ACS) support
To: jouni@qca.qualcomm.com
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 29, 2011 at 2:01 PM, Luis R. Rodriguez
<lrodriguez@qca.qualcomm.com> wrote:
> This v7 fixes an issue reported by MingAnn Ng devil_eddie01@hotmail.com where
> busy time is 0. We treat this as log2(0) as 0. Even if busy time is 0 the
> interference factor will end up being affected by the detected noise floor on
> this channel compared to the lowest noise floor on the band. The amount of time
> we dwell on the channel for monitoring will also affect the result.
>
> This v7 also changes the offchannel time from 5ms to 60ms to account possible
> calibrations hordware may do right after a channel change, specially for noise
> floor calibration. Once we are really happy with these values we may simply
> hide them from the user.

Well because of changes in hostapd I had to address one small merge
conflict after a rebase, so I'll simply resubmit the full series as
v7.

 Luis

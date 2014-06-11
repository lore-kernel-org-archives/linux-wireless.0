Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41264 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbaFKG6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 02:58:43 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq2so7091909pbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2014 23:58:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1402469724-22358-1-git-send-email-arik@wizery.com>
References: <1402469724-22358-1-git-send-email-arik@wizery.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 11 Jun 2014 09:58:27 +0300
Message-ID: <CA+XVXffrjDM_bW1Ltm0iZbEvJW98Sg7crcoSi9JXeHqRn8KbiA@mail.gmail.com> (sfid-20140611_085846_414596_0089C2D1)
Subject: Re: [PATCH 1/5] cfg80211: introduce regulatory flags controlling bw
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Arik Nemtsov <arik@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2014 at 9:55 AM, Arik Nemtsov <arik@wizery.com> wrote:
> Allow setting bandwidth related regulatory flags. These flags are mapped
> to the corresponding channel flags in the specified range.
> Make sure the new flags are consulted when calculating the maximum
> bandwidth allowed by a regulatory-rule.
>
> Also allow propagating the GO_CONCURRENT modifier from a reg-rule to a
> channel.
>
> Change-Id: Ic120a291ef7a56f2efa800e77e9689c6c421affa

Sorry about this..

Arik

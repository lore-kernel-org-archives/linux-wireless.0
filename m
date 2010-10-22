Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38404 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374Ab0JVQEj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 12:04:39 -0400
Received: by iwn34 with SMTP id 34so1102164iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 09:04:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=XU_wmmYfV+dd5yU=ZwjWsm-usxcLY71qCUY_o@mail.gmail.com>
References: <AANLkTimqQqo2F+UD7j0OUXn_YF3EvkO5z6Njdo-=dhnY@mail.gmail.com>
 <AANLkTik_Uj9adCUyOoMyx7t44AReK6yxcv_YLT_+Jm1U@mail.gmail.com> <AANLkTi=XU_wmmYfV+dd5yU=ZwjWsm-usxcLY71qCUY_o@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 22 Oct 2010 09:04:18 -0700
Message-ID: <AANLkTin+aKsPw5A+J_1FpDMYd76HgG7k+1E7GtL1eZ_X@mail.gmail.com>
Subject: Re: [PATCH] compat: Fixes missing sem member in struct device for RT
 PREEMPT prior to 2.6.34
To: Blaise Gassend <blaise@willowgarage.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 22, 2010 at 8:58 AM, Blaise Gassend <blaise@willowgarage.com> wrote:
> That was a diff against the master branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat.git that I
> cloned last night. I produced the patch with git diff. What should I
> have diffed against?

That's fine, for some reason it did not apply, but anyway I applied it
manually, thanks!!!

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58107 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab0JVAcg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 20:32:36 -0400
Received: by gxk3 with SMTP id 3so142436gxk.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Oct 2010 17:32:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010220930.01071.br1@einfach.org>
References: <1287616028-12547-1-git-send-email-lrodriguez@atheros.com>
 <4CC07CA9.4040808@candelatech.com> <201010220930.01071.br1@einfach.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 21 Oct 2010 17:32:15 -0700
Message-ID: <AANLkTi=wTsFnVZ=GGck_ArP6ubT_dOB41ut13od7biwT@mail.gmail.com>
Subject: Re: [PATCH 0/6] ath9k: fix RX poison issue
To: Bruno Randolf <br1@einfach.org>
Cc: Ben Greear <greearb@candelatech.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 21, 2010 at 5:30 PM, Bruno Randolf <br1@einfach.org> wrote:
> On Fri October 22 2010 02:47:21 Ben Greear wrote:
>> I tested this code when it was combined into a single patch.
>> There were still some issues, but I have no reason to believe
>> this patch set caused them.  This patch set significantly
>> improved stability in my testing with 130+ STA interfaces.
>
> one question: do you see similar issues with ath5k? i remember one bug is
> filed with a rx poision issue.

Hardware is similar so the I'd do the same locking.

  Luis

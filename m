Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57017 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab0JOV72 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 17:59:28 -0400
Received: by iwn35 with SMTP id 35so1335275iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Oct 2010 14:59:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1287179813-18427-1-git-send-email-greearb@candelatech.com>
References: <1287179813-18427-1-git-send-email-greearb@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 15 Oct 2010 14:59:02 -0700
Message-ID: <AANLkTikdEPQWXNiZF8jmXnX86ao7-fV+pgyJs5oP5eEU@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH] ath9k: Properly initialize ath_common->cc_lock.
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 15, 2010 at 2:56 PM,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> Otherwise, lockdep splats, at the least.

Thanks for the fix, please include the lockdep rant here on the commit log.

  Luis

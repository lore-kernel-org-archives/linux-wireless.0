Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:51325 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbYJJXwo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 19:52:44 -0400
Received: by gxk9 with SMTP id 9so1521862gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2008 16:52:43 -0700 (PDT)
Message-ID: <43e72e890810101652i6712f989r99f36b206ce01059@mail.gmail.com> (sfid-20081011_015247_343136_F21B230B)
Date: Fri, 10 Oct 2008 16:52:43 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/2] ath9k: remove nasty FAIL macro from ath9k_hw_reset()
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890810101359n529f932fw8cd47822b27b4685@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1223641374-11872-1-git-send-email-lrodriguez@atheros.com>
	 <1223667649.3748.38.camel@johannes.berg>
	 <43e72e890810101359n529f932fw8cd47822b27b4685@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 10, 2008 at 1:59 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:

> bad:
>        if (status)
>                *status = ecode;
>        return false;

Oh and for the record this is still requires more cleanup BTW, but
we'll get to it.. we keep at it.

  Luis

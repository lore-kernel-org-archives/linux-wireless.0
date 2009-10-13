Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:38925 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbZJMUIt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 16:08:49 -0400
Received: by iwn10 with SMTP id 10so2967034iwn.4
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2009 13:08:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890910131239x60c3f8d7j784dcf2a3cd9de51@mail.gmail.com>
References: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
	<1255382358-20760-2-git-send-email-hauke@hauke-m.de> <43e72e890910131239x60c3f8d7j784dcf2a3cd9de51@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 13 Oct 2009 13:07:53 -0700
Message-ID: <43e72e890910131307n112b7e88gfca5572aabeb0de2@mail.gmail.com>
Subject: Re: [PATCH 1/9] [compat-2.6 and compat-stable] Export
	round_jiffies_up again.
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, larry.finger@gmail.com,
	Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 13, 2009 at 12:39 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:

> because otherwise then we have here the define so existing
> wireless-testing code maps to the backport_round_jiffies_up(), and the
> declaration of round_jiffies_up() also gets preprocessed as
> backport_round_jiffies_up() -- the only thing missing would be the
> compat exported symbol but I saw that didn't change.

Come to think of it -- because of the define you added the
compat-2.6.28 code *will* rename the code to add the backport_ prefix
so that is why this compiles. I'll leave it like that. Thanks.

  Luis

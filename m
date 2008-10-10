Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:51101 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761690AbYJJTHs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 15:07:48 -0400
Received: by gxk9 with SMTP id 9so1183171gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2008 12:07:47 -0700 (PDT)
Message-ID: <43e72e890810101207h767353bem3a080aab27b7eb09@mail.gmail.com> (sfid-20081010_210754_111335_2DB3BEFE)
Date: Fri, 10 Oct 2008 12:07:47 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/1] Ath9k: fix uninitialized value in ath9k_hw_reset
Cc: jirislaby@gmail.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	jmalinen@atheros.com
In-Reply-To: <20081010.120050.161276431.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1223661403-21803-1-git-send-email-jirislaby@gmail.com>
	 <20081010.115318.85254002.davem@davemloft.net>
	 <43e72e890810101200g3f50b204t20ea782878217369@mail.gmail.com>
	 <20081010.120050.161276431.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 10, 2008 at 12:00 PM, David Miller <davem@davemloft.net> wrote:
> From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
> Date: Fri, 10 Oct 2008 12:00:17 -0700
>
>> Agreed, patches welcomed.
>
> Translation: "Fix it yourself if you care so much." :-/

Not really, I want to fix it, just want to fix aggregation too. OK
fine, I'll send a patch now.

  Luis

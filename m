Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38561 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab0IRW2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Sep 2010 18:28:08 -0400
Received: by iwn5 with SMTP id 5so3056120iwn.19
        for <linux-wireless@vger.kernel.org>; Sat, 18 Sep 2010 15:28:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1284803766-27710-1-git-send-email-helmut.schaa@googlemail.com>
References: <1284803766-27710-1-git-send-email-helmut.schaa@googlemail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 18 Sep 2010 15:27:48 -0700
Message-ID: <AANLkTikyaJO7AmdFeth+NB++6k-PfS0eaEP7g0ExnWdy@mail.gmail.com>
Subject: Re: [PATCH] compat-wireless: Select minstrel_ht as default rc algo
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: mcgrof@kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 18, 2010 at 2:56 AM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Wireless-testing is using minstrel_ht already as default rc algorithm.
> Do the same im compat-wireless. Setting CONFIG_MAC80211_RC_DEFAULT
> manually is needed in compat-wireless since it doesn't have the Kconfig
> magic to automagically select minstrel_ht if it is compiled in.
>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Thanks, applied and pushed.

  Luis

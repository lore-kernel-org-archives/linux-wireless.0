Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:36392 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965165AbcKJTqu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Nov 2016 14:46:50 -0500
Received: by mail-pf0-f180.google.com with SMTP id 189so151620256pfz.3
        for <linux-wireless@vger.kernel.org>; Thu, 10 Nov 2016 11:46:50 -0800 (PST)
Date: Thu, 10 Nov 2016 11:46:47 -0800
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v2 1/5] mwifiex: remove redundant condition in main
 process
Message-ID: <20161110194646.GA85922@google.com> (sfid-20161110_204700_713961_E2A77136)
References: <1477559563-18328-1-git-send-email-akarwar@marvell.com>
 <20161027183536.GA28717@localhost>
 <eda7a256a6574baeb8e1a12c15c2e6b0@SC-EXCH02.marvell.com>
 <878tsvruum.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <878tsvruum.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 07, 2016 at 08:46:41PM +0200, Kalle Valo wrote:
> Xinming Hu <huxm@marvell.com> writes:
> 
> > We have include below change in latest submit https://patchwork.kernel.org/patch/9407283/
> > Please drop this patch.
> 
> When making changes please resend the whole patchset. I do not want to
> individually pick patches from different places, that will eventually go
> wrong anyway. So I just apply full patchsets.

I'm going to assume that Xinming intended that the entire series be
resent, possibly without this patch. There were enough other issues in
the series anyway.

Brian

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65499 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab0LCT7k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 14:59:40 -0500
Received: by fxm20 with SMTP id 20so2558291fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Dec 2010 11:59:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291313961-10692-1-git-send-email-kilroyd@googlemail.com>
References: <1291313961-10692-1-git-send-email-kilroyd@googlemail.com>
Date: Fri, 3 Dec 2010 19:59:38 +0000
Message-ID: <AANLkTi=upvT47Dz45fnEhi8CDiwevg_2dDs7vvemsGAg@mail.gmail.com>
Subject: Re: [PATCH] orinoco: allow IW_AUTH_MFP to pass through
From: Dave Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: comes@naic.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 2, 2010 at 6:19 PM, David Kilroy <kilroyd@googlemail.com> wrote:
> The card doesn't support MFP, so silently accept DISABLED and OPTIONAL
> settings.
>
> Signed-off by: David Kilroy <kilroyd@googlemail.com>
> Reported by: Giacomo Comes <comes@naic.edu>
> ---
>
> Compile tested. I'm not sure this fixes the issue, because it looks like
> wpa_supplicant is still waiting for authentication to succeed. However,
> it has probably not called the commit handler.

John, in case you missed it in the other orinoco thread, Giacomo has
confirmed this patch works.

Dave.

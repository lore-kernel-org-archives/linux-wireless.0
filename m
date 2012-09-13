Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44332 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752749Ab2IMTJt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2012 15:09:49 -0400
MIME-Version: 1.0
In-Reply-To: <1347344964-4120-1-git-send-email-bkamatch@qca.qualcomm.com>
References: <1347344964-4120-1-git-send-email-bkamatch@qca.qualcomm.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 13 Sep 2012 12:09:27 -0700
Message-ID: <CAB=NE6UJOgP03t+eN_EDM+92JejAFfsqDdhF+2DD_FpD7M5JZg@mail.gmail.com> (sfid-20120913_210953_868226_11C1EF68)
Subject: Re: [PATCH] compat-drivers: Use GIT_TREE variable.
To: Bala Shanmugam <bkamatch@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, backports@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 10, 2012 at 11:29 PM, Bala Shanmugam
<bkamatch@qca.qualcomm.com> wrote:
> In gen-stable-release.sh stable git tree path is hardcoded.
> Use GIT_TREE environment variable if specified.
>
> Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>

Thanks, applied and pushed! In the future please subscribe and use the
new dedicated mailing list for the project: backports@vger.kernel.org.
For more details:

https://backports.wiki.kernel.org/

  Luis

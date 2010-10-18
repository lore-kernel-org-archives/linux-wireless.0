Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56129 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab0JRSGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Oct 2010 14:06:20 -0400
Received: by ywi6 with SMTP id 6so597089ywi.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Oct 2010 11:06:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <507036.8029.qm@web56804.mail.re3.yahoo.com>
References: <507036.8029.qm@web56804.mail.re3.yahoo.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 18 Oct 2010 11:05:59 -0700
Message-ID: <AANLkTinNMBV=UUV3VOgPE+oFCKTG3aaDW2cpnC0cXgX5@mail.gmail.com>
Subject: Re: [PATCH] compat-wireless: enable uninstall for staging & atlxx
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 18, 2010 at 6:44 AM, Walter Goldens
<goldenstranger@yahoo.com> wrote:
> - enable 'make uninstall' for staging - brcm80211, ath6kl and ethernet atlxx
> - add atlxx to 'modprobe -l' list
>
> Signed-off-by: Walter Goldens <goldenstranger@yahoo.com>

applied and pushed, thanks!

  Luis

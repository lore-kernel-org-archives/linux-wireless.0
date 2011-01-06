Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56034 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab1AFVB3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 16:01:29 -0500
Received: by iwn9 with SMTP id 9so16654135iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 13:01:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1294334212-20530-2-git-send-email-hauke@hauke-m.de>
References: <1294334212-20530-1-git-send-email-hauke@hauke-m.de> <1294334212-20530-2-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 6 Jan 2011 13:01:08 -0800
Message-ID: <AANLkTi=EPtvPYYFo4f=E_MHvNvpCwecpjnCjVnCy99Ht@mail.gmail.com>
Subject: Re: [PATCH 2/2] compat-wireless: use backported kfifo
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 6, 2011 at 9:16 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Now compat contains a backport of the kfifo implementation and we do
> not have to patch the driver to use the old interface.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Sweet! Applied and pushed, thanks!

  Luis

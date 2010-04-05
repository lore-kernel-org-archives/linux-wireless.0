Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46108 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364Ab0DEVXi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Apr 2010 17:23:38 -0400
Received: by pwj9 with SMTP id 9so702835pwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Apr 2010 14:23:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1270501410-3956-2-git-send-email-hauke@hauke-m.de>
References: <1270501410-3956-1-git-send-email-hauke@hauke-m.de>
	<1270501410-3956-2-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 5 Apr 2010 14:23:18 -0700
Message-ID: <n2v43e72e891004051423t861b56b7k8d501cb6bccc15c0@mail.gmail.com>
Subject: Re: [PATCH 2/2] compat-wireless: fix use of device_create
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 5, 2010 at 2:03 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> The signature of device_create changed in the last kernel version.
> Backporting it in compat is hard because of the use of var args.
>

thanks all 3 patches applied and pushed out.

  Luis

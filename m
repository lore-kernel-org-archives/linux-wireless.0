Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:54512 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbZI3Tac (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 15:30:32 -0400
Received: by iwn8 with SMTP id 8so3840266iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2009 12:30:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090930170000.09582F88DD@sepang.rtg.net>
References: <20090930170000.09582F88DD@sepang.rtg.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 30 Sep 2009 12:30:16 -0700
Message-ID: <43e72e890909301230r55d7b165w198a7c66acdf8e46@mail.gmail.com>
Subject: Re: [PATCH] compat-wireless: Fix b44 build issues.
To: Tim Gardner <timg@tpi.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 30, 2009 at 10:00 AM, Tim Gardner <timg@tpi.com> wrote:
> From 553180d80860c6090b7d82f809ea7131afca01d6 Mon Sep 17 00:00:00 2001
> From: Tim Gardner <tim.gardner@canonical.com>
> Date: Wed, 30 Sep 2009 10:02:35 -0600
> Subject: [PATCH] compat-wireless: Fix b44 build issues.
>
> Even though CONFIG_B44 is defined, there is no Makefile
> created in drivers/net. This failure to build allows the
> in-kernel version of b44 to get loaded with a compat-wireless
> version of ssb.ko, never a good thing.
>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>

Applied thanks. I must've fat fingered a commit and push after testing
driver-select, whoopsie.. sorry about that.

  Luis

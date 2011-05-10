Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42412 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab1EJXT6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 19:19:58 -0400
Received: by iwn34 with SMTP id 34so5631467iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2011 16:19:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305065015-27078-1-git-send-email-hauke@hauke-m.de>
References: <1305065015-27078-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 10 May 2011 16:19:38 -0700
Message-ID: <BANLkTi=sa_5EneGUo+0rAdyrFFCe3AQ_eg@mail.gmail.com> (sfid-20110511_012001_899011_DA924A81)
Subject: Re: [PATCH v2 3/3] compat-wireless: enable RT33XX support.
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org,
	Walter Goldens <goldenstranger@yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 10, 2011 at 3:03 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This is based on a patch by Walter Goldens.
>
> RT2800PCI_RT35XX, RT2800PCI_RT53XX, RT2800USB_RT35XX and
> RT2800USB_RT53XX are still experimental and deactivated because of that.
>
> CC: Walter Goldens <goldenstranger@yahoo.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
> v2: do not activate CONFIG_RT2800USB_RT53XX and CONFIG_RT2800PCI_RT53XX
>    by default as they are not stable.

Applied, and pushed, thanks!

  Luis

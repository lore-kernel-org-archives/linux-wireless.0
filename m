Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34400 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab0HQWCi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 18:02:38 -0400
Received: by gxk23 with SMTP id 23so2790646gxk.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Aug 2010 15:02:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1282069869-22300-1-git-send-email-hauke@hauke-m.de>
References: <1282069869-22300-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 17 Aug 2010 15:02:17 -0700
Message-ID: <AANLkTinS=nXje5hJ=Eq4AuXvMUEhDbquB=C_oDXA+pHk@mail.gmail.com>
Subject: Re: [PATCH 0/3] compat-wireless: miscellaneous fixes
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 17, 2010 at 11:31 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This was build tested in combination with the patches to compat.
>
> Hauke Mehrtens (3):
>  compat-wireless: deactivate namespace
>  compat-wireless: make compat-2.6.37.c build
>  compat-wireless: fix hidp_output_raw_report

Great thanks! Applied and pushed all out. Are any of these stable
fixes into the respective stable branches of compat-wireless.git? How
about the compat.git ones?

  Luis

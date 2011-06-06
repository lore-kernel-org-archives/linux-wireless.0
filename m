Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61251 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab1FFKau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 06:30:50 -0400
Received: by mail-qw0-f46.google.com with SMTP id 3so1575796qwk.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 03:30:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1307311658-15853-6-git-send-email-hauke@hauke-m.de>
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
	<1307311658-15853-6-git-send-email-hauke@hauke-m.de>
Date: Mon, 6 Jun 2011 12:30:49 +0200
Message-ID: <BANLkTik9u5QhxdeaGMUyYYK-W8hSkQb-Wg@mail.gmail.com> (sfid-20110606_123053_186964_C3490A56)
Subject: Re: [RFC][PATCH 05/10] bcma: add serial console support
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, linux-mips@linux-mips.org,
	mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/6/6 Hauke Mehrtens <hauke@hauke-m.de>:
> +       if ((ccrev >= 11) && (ccrev != 15) && (ccrev != 20)) {
> +       ....
> +       } else
> +               pr_err("serial not supported on this device ccrev: 0x%x\n",
> +                      ccrev);

Please use scripts/checkpatch* for your patches. I believe it will
alert you about lacking brackets for "else" (kernel coding style).

-- 
Rafał

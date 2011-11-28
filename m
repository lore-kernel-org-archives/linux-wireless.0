Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61302 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab1K1N4d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 08:56:33 -0500
Received: by qadc14 with SMTP id c14so1139790qad.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 05:56:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321649564-12954-1-git-send-email-linville@tuxdriver.com>
References: <1321649564-12954-1-git-send-email-linville@tuxdriver.com>
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Date: Mon, 28 Nov 2011 08:56:11 -0500
Message-ID: <CAB=NE6WydOoNO+P-XizhmHGSFHhSGTDnYBgL1iUBZoWzhnSHiw@mail.gmail.com> (sfid-20111128_145653_703530_09CE8885)
Subject: Re: [PATCH v2] compat: implement dummy security_sk_clone
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 18, 2011 at 3:52 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> This has been defined in include/linux/security.h for some time, but was
> only given an EXPORT_SYMBOL for 3.1.  Add a compat_* definition to avoid
> breaking the module load with an undefined symbol.
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

applied, and pushed, thanks!

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52414 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab0GUU7B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 16:59:01 -0400
Received: by pzk26 with SMTP id 26so2245776pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jul 2010 13:59:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1279735518-12515-1-git-send-email-linville@tuxdriver.com>
References: <1279735518-12515-1-git-send-email-linville@tuxdriver.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 21 Jul 2010 13:58:40 -0700
Message-ID: <AANLkTikWo6tjyYCDMgoA9WXvbNaWIe_oSp180jcdtWgy@mail.gmail.com>
Subject: Re: [PATCH] wireless: remove prism54
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 21, 2010 at 11:05 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> This driver is no longer necessary due to p54pci.  It has seen very
> little maintenance for some time, and at least Fedora has had it
> disabled without any user complaints.
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Hm, we had a few users report back that only with prism54 and not
p54pci could they get their device functional. IIRC Christian noted
some issues with the EEPROM, and it seems the fault was on the
manufacturer. My memory may be foggy but indeed I do remember a few
users did complain about the feature removal plan. I can dig these
e-mails up if needed.

  Luis

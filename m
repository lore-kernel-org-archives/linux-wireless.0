Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57231 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab2HNQuL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2012 12:50:11 -0400
Received: by ghrr11 with SMTP id r11so669943ghr.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Aug 2012 09:50:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344935164-21377-1-git-send-email-ozancag@gmail.com>
References: <1344935164-21377-1-git-send-email-ozancag@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 14 Aug 2012 09:49:50 -0700
Message-ID: <CAB=NE6WL=vCdmzeu+F_q0qtdUqiQztwheGm8XAU2wN5y3aLDmg@mail.gmail.com> (sfid-20120814_185017_619907_DBC9CA9A)
Subject: Re: [PATCH] compat: Drop redundant udev rules file
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: mcgrof@kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 14, 2012 at 2:06 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> udev rules for Ubuntu and the-rest-of-world are the same. Drop one of
> them and use the other one.
>
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>

Makes sense, thanks, applied and pushed.

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.223.194]:44984 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab0AGW0t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 17:26:49 -0500
Received: by iwn32 with SMTP id 32so2683024iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2010 14:26:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1262903089-1958-1-git-send-email-lrodriguez@atheros.com>
References: <1262903089-1958-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 7 Jan 2010 14:26:29 -0800
Message-ID: <43e72e891001071426l754d254jaf20a31a120b6d56@mail.gmail.com>
Subject: Re: [PATCH] hostapd: add country IE debugging options
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 7, 2010 at 2:24 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> If you want to debug parsing of country IEs on your
> client you can enable the CONFIG_COUNTRY_DBG and then
> select the desired triplet. We add four tests cases you
> can use.
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Please ignore this one, I posted it to the wrong list.

  Luis

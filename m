Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:40042 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759403AbZD2SUB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2009 14:20:01 -0400
Received: by rv-out-0506.google.com with SMTP id f9so1024403rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2009 11:20:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1241002918-27818-1-git-send-email-juhosg@openwrt.org>
References: <1241002918-27818-1-git-send-email-juhosg@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 29 Apr 2009 11:19:41 -0700
Message-ID: <43e72e890904291119h55e957ean7cdc028534691c2@mail.gmail.com> (sfid-20090429_202018_674666_BD87D3E6)
Subject: Re: [PATCH] ath9k: uninline ath9k_io{read,write}32 routines
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 29, 2009 at 4:01 AM, Gabor Juhos <juhosg@openwrt.org> wrote:
> The spin_lock handling uses lots of instructions on some archs.
> With this patch the size of the ath9k module will be significantly
> smaller.
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis

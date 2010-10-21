Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56790 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881Ab0JUORR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 10:17:17 -0400
Received: by iwn7 with SMTP id 7so3701379iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Oct 2010 07:17:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1287668824-3096-1-git-send-email-senthilkumar@atheros.com>
References: <1287668824-3096-1-git-send-email-senthilkumar@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 21 Oct 2010 07:16:56 -0700
Message-ID: <AANLkTim0RfV8V4r2Je7DcqXgyWnNSPT4DrGYe8KO0Gi_@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] cfg80211: add debug prints for when we ignore
 regulatory hints
To: Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Easwar Krishnan <easwar.krishnan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 21, 2010 at 6:47 AM, Senthil Balasubramanian
<senthilkumar@atheros.com> wrote:
> From: Luis R. Rodriguez <lrodriguez@atheros.com>
>
> This can help with debugging issues. You will only see
> these with CONFIG_CFG80211_REG_DEBUG enabled.
>
> Cc: Easwar Krishnan <easwar.krishnan@atheros.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
> ---
> v2 -- brought in reg_initiator_name under reg debug to get rid of a
> warning  message.

Thanks!!

  Luis

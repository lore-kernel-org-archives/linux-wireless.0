Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55118 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab2DSLCT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 07:02:19 -0400
Received: by vcqp1 with SMTP id p1so5510836vcq.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 04:02:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1334827233-32686-1-git-send-email-anisse@astier.eu>
References: <1334827233-32686-1-git-send-email-anisse@astier.eu>
Date: Thu, 19 Apr 2012 13:02:18 +0200
Message-ID: <CAOZOX0XeFDwTM_Uncg1+jNExv2eBixYEVwMQ9R57SHmbJe4LvQ@mail.gmail.com> (sfid-20120419_130222_420357_A84202B9)
Subject: Re: [PATCH v2 1/2] rt2800: debugfs register access: BBP is 256 bytes big
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Anisse Astier <anisse@astier.eu>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linville@tuxdriver.com, Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 19, 2012 at 11:20 AM, Anisse Astier <anisse@astier.eu> wrote:
> We're already using BBP for values > 128. Make that explicit and allow
> debugfs access.
>
> Signed-off-by: Anisse Astier <anisse@astier.eu>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> Changes since v1: none
> ---
>  drivers/net/wireless/rt2x00/rt2800.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index 1ce2634..d91f4f6 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -99,7 +99,7 @@
>  #define EEPROM_BASE                    0x0000
>  #define EEPROM_SIZE                    0x0110
>  #define BBP_BASE                       0x0000
> -#define BBP_SIZE                       0x0080
> +#define BBP_SIZE                       0x00ff
>  #define RF_BASE                                0x0004
>  #define RF_SIZE                                0x0010
>
> --
> 1.7.9.4
>

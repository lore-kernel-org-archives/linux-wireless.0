Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58865 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab0H3WqE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 18:46:04 -0400
Received: by bwz11 with SMTP id 11so4077221bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Aug 2010 15:46:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201008302242.19395.chunkeey@googlemail.com>
References: <201008302242.19395.chunkeey@googlemail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 31 Aug 2010 08:45:42 +1000
Message-ID: <AANLkTinXJN7q3CXLVxNP=S2fGQHQJxLEmwvbAV17+Q_i@mail.gmail.com>
Subject: Re: [RFT 6/6] carl9170usb: Makefile, Kconfig files and MAINTAINERS
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian,

Minor, *minor* nit.

On Tue, Aug 31, 2010 at 06:42, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 63e441b..1f10089 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1119,6 +1119,7 @@ L:        linux-wireless@vger.kernel.org
>  W:     http://wireless.kernel.org/en/users/Drivers/ar9170
>  S:     Maintained
>  F:     drivers/net/wireless/ath/ar9170/
> +F:     drivers/net/wireless/ath/carl9170/
>
>  ATK0110 HWMON DRIVER
>  M:     Luca Tettamanti <kronos.it@gmail.com>

As carl9170 has a separate website, would it make sense for it to also
have a separate MAINTAINERS entry?

Also, patch 1/6 is signed off by root, you may want to fix that.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/

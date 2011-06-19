Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36640 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab1FSXpI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 19:45:08 -0400
Received: by iwn6 with SMTP id 6so751463iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jun 2011 16:45:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1308520209-668-6-git-send-email-hauke@hauke-m.de>
References: <1308520209-668-1-git-send-email-hauke@hauke-m.de> <1308520209-668-6-git-send-email-hauke@hauke-m.de>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 20 Jun 2011 09:44:48 +1000
Message-ID: <BANLkTinCrAMa3bmTsKpu4y7QGbSiU9jMXQ@mail.gmail.com> (sfid-20110620_014513_301081_00256232)
Subject: Re: [RFC v2 05/12] bcma: add mips driver
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	linux-mips@linux-mips.org, mb@bu3sch.de, george@znau.edu.ua,
	arend@broadcom.com, b43-dev@lists.infradead.org,
	bernhardloos@googlemail.com, arnd@arndb.de, sshtylyov@mvista.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hauke,

One minor comment

On Mon, Jun 20, 2011 at 07:50, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
> new file mode 100644
> index 0000000..d49f9af
> --- /dev/null
> +++ b/drivers/bcma/driver_mips.c
> @@ -0,0 +1,232 @@
> +/*
> + * Sonics Silicon Backplane

Err, this is for BCMA, not SSB =)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/

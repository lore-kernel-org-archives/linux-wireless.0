Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:59341 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab0AUP5y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 10:57:54 -0500
Received: by yxe17 with SMTP id 17so107662yxe.33
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2010 07:57:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201001211305.28456.mb@bu3sch.de>
References: <201001101152.34316.mb@bu3sch.de>
	 <43e72e891001151447u39ad494ah6861926db0c50907@mail.gmail.com>
	 <201001152350.06930.mb@bu3sch.de> <201001211305.28456.mb@bu3sch.de>
Date: Thu, 21 Jan 2010 10:57:53 -0500
Message-ID: <b6c5339f1001210757j14bd6ed7ub2ff71a825990f08@mail.gmail.com>
Subject: Re: Ath5k on 2.6.32 suddenly fails
From: Bob Copeland <me@bobcopeland.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 21, 2010 at 7:05 AM, Michael Buesch <mb@bu3sch.de> wrote:
> So so AP failed again.
>
> This time with an older failure that I already reported in the past.
> [210174.502973] ath5k phy0: no further txbuf available, dropping packet

Ok, I posted a patch for this last night -- sorry for sitting on it so
long.

-- 
Bob Copeland %% www.bobcopeland.com

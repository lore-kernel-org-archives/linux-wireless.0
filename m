Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40004 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933093Ab0FQRjW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jun 2010 13:39:22 -0400
Received: by gye5 with SMTP id 5so162757gye.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jun 2010 10:39:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C1926E7.1070503@cortland.com>
References: <4C1926E7.1070503@cortland.com>
Date: Thu, 17 Jun 2010 13:39:17 -0400
Message-ID: <AANLkTil-qhJ7fO3RNm4xwG1fA6uKeTkrD352ICU-z8Ab@mail.gmail.com>
Subject: Re: OOPS in ath5k when setting coverage class
From: Bob Copeland <me@bobcopeland.com>
To: Steve Brown <sbrown@cortland.com>
Cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 16, 2010 at 3:32 PM, Steve Brown <sbrown@cortland.com> wrote:
> From the printk's, it appears that ah->ah_current_channel isn't set at the
> time of the callback.
>
> The following produces the oops with compat-wireless-2010-06-10.

Thanks for the report - your analysis looks spot on.
I'll take a look tonight.

-- 
Bob Copeland %% www.bobcopeland.com

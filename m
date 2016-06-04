Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:35942 "EHLO
	mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbcFDKnn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 06:43:43 -0400
MIME-Version: 1.0
In-Reply-To: <1465000772-1447-1-git-send-email-hgsipiere@gmail.com>
References: <1465000772-1447-1-git-send-email-hgsipiere@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sat, 4 Jun 2016 20:35:46 +1000
Message-ID: <CAGRGNgV_tcM+3L7eWjWfuOEeWWo+ThWK_+GTNiGbZLL=acg8VA@mail.gmail.com> (sfid-20160604_124352_012939_F5028535)
Subject: Re: [PATCH] Drivers: ssb: Fix bare unsigned and changed to trailing comments
To: Hugh Sipiere <hgsipiere@gmail.com>
Cc: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hugh,

On Sat, Jun 4, 2016 at 10:39 AM, Hugh Sipiere <hgsipiere@gmail.com> wrote:
> I changed drivers/ssb/driver_gpio.c to better fit the coding style.
> I changed unsigned to unsigned int
> Two comments were changed to not end on a line with the text.
>
> Signed-off-by: Hugh Sipiere <hgsipiere@gmail.com>

You should separate the changes into two patches, one to change
"unsigned" to "unsigned int" and one to fix the comments.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/

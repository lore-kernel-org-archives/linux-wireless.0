Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:34609 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbbGJG2Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2015 02:28:25 -0400
Received: by igoe12 with SMTP id e12so29191967igo.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 23:28:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f2a06d72df5600df11f0591cfdd2a1178f11d54e.1436504598.git.johnny.kim@atmel.com>
References: <5398ffb63f5799c0fbab0c2fe1416bb09c4bae6b.1436504598.git.johnny.kim@atmel.com>
 <f2a06d72df5600df11f0591cfdd2a1178f11d54e.1436504598.git.johnny.kim@atmel.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 10 Jul 2015 16:28:05 +1000
Message-ID: <CAGRGNgUqBQpkvF6u3bLhRevkcZCNREZSATOqhjTt6YkUNQNNSw@mail.gmail.com> (sfid-20150710_082831_937134_A56FADA7)
Subject: Re: [PATCH 4/5] staging: wilc1000: SendConfigPkt(): replace integer
 with void pointer
To: Johnny Kim <johnny.kim@atmel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Chris Park <chris.park@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>, tony.cho@atmel.com,
	Nicolas.FERRE@atmel.com, Dean Lee <dean.lee@atmel.com>,
	austin.shin@atmel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johnny,

On Fri, Jul 10, 2015 at 3:55 PM, Johnny Kim <johnny.kim@atmel.com> wrote:
> This patch replaces a integer argument of SendConfigPkt function with
> void type pointer and fix code that the function is called.
>
> Because tstrWILC_WFIDrv structure is defined after SendConfigPkt function
> is defined, the function can not refer to the structure type.
> So this patch change the argument to void type pointer.

Same comments again, why not move the structure definition?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/

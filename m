Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:47062 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751305Ab0JYHt7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 03:49:59 -0400
Message-ID: <4CC540F1.2070303@gmx.net>
Date: Mon, 25 Oct 2010 10:33:53 +0200
From: George <george.news@gmx.net>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: Grazvydas Ignotas <notasas@gmail.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Compat-wireless N900
References: <4CB6BE57.8010401@gmx.net>	<1287071844.11341.5.camel@gnutoo-laptop>	<AANLkTikosEtFnWqRVzMBKtNsB=aqOpqQFKDOZS3+pXTE@mail.gmail.com>	<4CB74759.3030807@gmx.net>	<AANLkTi=1Ar-gzRaskHGDLmkaDnr=9+oZnA=qBLCYcUAi@mail.gmail.com>	<4CB7F7C7.7030804@gmx.net>	<AANLkTi=u+mT2Xd0=0vt4uaf9hSnnkPKY+wN6DjAxME3m@mail.gmail.com>	<4CBABB84.1090100@gmx.net> <4CBC7725.7050202@gmx.net>	<AANLkTincCSBfwa_Y-cy_42HfU5kP1puCbi2-dBwGkkHu@mail.gmail.com>	<4CBC9A51.8030309@gmx.net> <1287427291.8043.2.camel@powerslave>	<1287428554.8043.6.camel@powerslave> <4CBD52DE.9090804@gmx.net>	<AANLkTi=dGSVBrdDXwJgmOjEGX+i+=P_KibiJd+NNMGfy@mail.gmail.com>	<4CBDB654.6060702@gmx.net>	<AANLkTimyCv6U+Yjf7q0OFEYF3PHr5PfACSpbXbTi_PZe@mail.gmail.com>	<4CBDBEDB.3070407@gmx.net>	<AANLkTik3ZdZov4OTn0NnnPe_ZUaRh_w0db4bwLYVGCRR@mail.gmail.com>	<4CBE9C4F.7050806@gmx.net> <87ocaj1120.fsf@purkki.adurom.net>
In-Reply-To: <87ocaj1120.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25/10/2010 4:03, Kalle Valo wrote:
> George<george.news@gmx.net>  writes:
>
>> It seems that it tries to do something but it is not finally done.
>> However, as you can see it seems there is no error (at least
>> reported). Could it be that spi_read buf is almost everytime reading
>> 00 00 00 00?
>
> If you get nothing but zeros back from the device, most likely that
> means that it's not powered up properly.
>
> wl1251 chip on n900 is powered up by using a gpio line. I'm worried
> that the struct wl12xx_platform_data wl1251 wireless-compat driver
> expects (defined in /include/linux/wl12xx.h) doesn't match what the
> old maemo kernel provides. Unfortunately I can't remember anymore what
> the platform data was like in maemo kernels and there's no easy way
> for me to check that right now.
>

Thanks a lot for that hint. Now I'm involved in another issue but when I 
have more time I will look at those .h, but don't expect too much from 
me as I'm not expert but just user.

Thanks a lot.

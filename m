Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37187 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab3EHWqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 18:46:25 -0400
Received: by mail-wi0-f179.google.com with SMTP id l13so2471505wie.6
        for <linux-wireless@vger.kernel.org>; Wed, 08 May 2013 15:46:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1368015905.17674.11.camel@bigdick-desktop>
References: <1368015905.17674.11.camel@bigdick-desktop>
Date: Wed, 8 May 2013 15:46:24 -0700
Message-ID: <CAJ-Vmonq1YN2NoWFMXtqVYr16eTD=mZ0n74CCEhMHK=05M1xyQ@mail.gmail.com> (sfid-20130509_004628_879229_4923CD6B)
Subject: Re: atheros AR5B22, using ath9k, can't switch between inscure and WEP/WPA
From: Adrian Chadd <adrian@freebsd.org>
To: Wally <wally.yeh@a-trust.com.tw>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.. AR5B22? Which chip does that probe as?



Adrian


On 8 May 2013 05:25, Wally <wally.yeh@a-trust.com.tw> wrote:
> Hi, guys:
>     Recently I got a atheros mini-PCIE wifi module AR5B22, so I download
> the latest version of compat-driver(compat-drivers-2013-03-28.tar.gz),
> and build it for armel on my arm board, it works great but with one
> little problem:
>
> If I connect to an inscure AP then change to a WEP/WPA AP, I can't
> connect the inscure one again, I have to run "modprobe -r ath9k;
> modprobe ath9k" to connect the inscure AP.
>
>     I think this may be a bug in the ath9k driver, I also search this
> bug on web but without an answer, so I send this letter for help.
>
>     Any advice would be grateful, thanks.
>
> Wally
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

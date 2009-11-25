Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f197.google.com ([209.85.223.197]:54592 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbZKYG5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 01:57:39 -0500
Received: by iwn35 with SMTP id 35so1971653iwn.4
        for <linux-wireless@vger.kernel.org>; Tue, 24 Nov 2009 22:57:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091125061834.GA27936@vasanth-laptop>
References: <1259116677-2249-1-git-send-email-lrodriguez@atheros.com>
	<20091125061834.GA27936@vasanth-laptop>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 24 Nov 2009 22:50:13 -0800
Message-ID: <43e72e890911242250o336b4891leb0006cbd4ba464@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Fix maximum tx fifo settings for single stream
	devices
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Kyungwan Nam <Kyungwan.Nam@atheros.com>,
	Bennyam Malavazi <Bennyam.Malavazi@atheros.com>,
	Stephen Chen <Stephen.Chen@atheros.com>,
	Shan Palanisamy <Shan.Palanisamy@atheros.com>,
	Paul Shaw <Paul.Shaw@atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>,
	stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 24, 2009 at 10:18 PM, Vasanthakumar Thiagarajan
<vasanth@atheros.com> wrote:
> On Wed, Nov 25, 2009 at 08:07:57AM +0530, Luis Rodriguez wrote:
>> +
>> +       if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
>> +               pCap->tx_triglevel_max = MAX_TX_FIFO_THRESHOLD >> 1;
>> +       else
>> +               pCap->tx_triglevel_max = MAX_TX_FIFO_THRESHOLD;
>
> I missed this one, thanks.

We got AR9285 in on 2.6.29 so I forgot to cc stable on the patch,
please let me know if you require some help porting this.

  Luis

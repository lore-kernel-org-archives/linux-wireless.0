Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1546 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844Ab1EVMtq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 08:49:46 -0400
Message-ID: <4DD9065C.70107@broadcom.com> (sfid-20110522_144950_878180_6EF0906A)
Date: Sun, 22 May 2011 14:49:32 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Nicolas Kaiser" <nikai@nikai.net>
cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Dan Carpenter" <error27@gmail.com>
Subject: Re: [RFC] lib: crc8: add new library module providing crc8
 algorithm
References: <1306051680-2354-1-git-send-email-arend@broadcom.com>
 <20110522105956.3b7a9fa2@absol.kitzblitz>
In-Reply-To: <20110522105956.3b7a9fa2@absol.kitzblitz>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/22/2011 10:59 AM, Nicolas Kaiser wrote:
> * "Arend van Spriel"<arend@broadcom.com>:
>> +/**
>> + * crc8() - calculate a crc8 over the given input data
>> + *
>> + * @pdata:	pointer to data buffer.
>> + * @nbytes:	number of bytes in data buffer.
>> + * @crc:	previous returned crc8 value.
>> + *
>> + * The CRC8 is calculated using the polynomial given below.
>> + *
>> + * x^8 + x^7 +x^6 + x^4 + x^2 + 1
>                   ^
> Could you possibly add a space here ...
>
>> +/*
>> + * table for crc8 calculation based on following polynomial:
>> + *	x^8 + x^7 +x^6 + x^4 + x^2 + 1
>                     ^
>             ... and here?
>
> Best regards,
> Nicolas Kaiser
>

Done. Will wait for some more feedback before posting a new version.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --



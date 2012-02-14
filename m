Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40700 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554Ab2BNNfT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 08:35:19 -0500
Received: by mail-we0-f174.google.com with SMTP id b13so4154272wer.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2012 05:35:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <400C43189542CE41BC0A5B252FC90136BC8414CAF4@SJEXCHCCR02.corp.ad.broadcom.com>
References: <20120214040120.GA2077@eris.garyseven.net>
	<400C43189542CE41BC0A5B252FC90136BC8414CAF4@SJEXCHCCR02.corp.ad.broadcom.com>
Date: Tue, 14 Feb 2012 14:35:19 +0100
Message-ID: <CACna6rys1WQtjEwv3KXU+n--Opq0uHqUuXZF720eNELvOzkH6w@mail.gmail.com> (sfid-20120214_143522_889391_FF835675)
Subject: Re: [RFC] use alternate SPROM offset for 43224
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend Van Spriel <arend@broadcom.com>
Cc: "Saul St. John" <saul.stjohn@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 14 lutego 2012 11:07 użytkownik Arend Van Spriel
<arend@broadcom.com> napisał:
>> owner@vger.kernel.org] On Behalf Of Saul St. John
>> Sent: dinsdag 14 februari 2012 5:01
>>
>> I don't know if this is correct in the general sense, but the wireless
>> on my
>> mid-2010 MacBook Pro doesn't work without it.
>>
>> Signed-off-by: Saul St. John <saul.stjohn@gmail.com>
>
> Does this patch solve the same issue as [1] with title:
>
> [PATCH] bcma: don't fail for bad SPROM CRC
>
> Gr. AvS
>
> [1] http://www.spinics.net/lists/netdev/msg187943.html

Not really, that patch didn't fix reading SPROM data.

-- 
Rafał

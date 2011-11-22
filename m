Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65393 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab1KVAWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 19:22:53 -0500
Received: by vbbfc21 with SMTP id fc21so3161763vbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2011 16:22:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ECAE912.8020603@broadcom.com>
References: <CADrAYBnwWEaigcgQYYk6V3VEuEYyrmzJQXegKVk6TgOTPh5N8A@mail.gmail.com>
	<4ECA8908.7070304@broadcom.com>
	<4ECA98DB.4030608@broadcom.com>
	<CADrAYBk7_fsVJUAYNqEZpdBPKOTGUai_UhPT9LMHaEyY+Zm24w@mail.gmail.com>
	<4ECAAD6C.4080103@broadcom.com>
	<CADrAYBndEsNz5nypirSxQPObpSV5BWARWOQzwmBTmzg+tgUbBA@mail.gmail.com>
	<CADrAYB=wDwrzCFEi4-PFepLiLMbPLAGxoaNGtXBaPZPR1onokA@mail.gmail.com>
	<4ECAC99B.8090507@broadcom.com>
	<CADrAYBmhBWVDC=K+F-NU6WkUv-M=WddWvU1pe9AXABEinUBGvQ@mail.gmail.com>
	<4ECAD52A.6050509@broadcom.com>
	<CADrAYBntm4GuhcZaErKimv4Z4Nt+Z6=67qdwi7eomZpTOoQsnQ@mail.gmail.com>
	<4F34EB345A846E42B8D432EA578382CC154E402FB4@SJEXCHCCR01.corp.ad.broadcom.com>
	<CADrAYBmD+OzXOLyunz6guyYzwn-mXuHtEaX-7cAVy7QmWp603A@mail.gmail.com>
	<4ECAE525.6030206@broadcom.com>
	<CADrAYBkL_Am57Vmo=mbJpGGZy81Tt6VoBfWt0_pb3F7wnL5Drg@mail.gmail.com>
	<4ECAE912.8020603@broadcom.com>
Date: Tue, 22 Nov 2011 01:22:52 +0100
Message-ID: <CADrAYB=TS3HmBO_mHqP+RAskTX0NnsKJdmF3hEU3LejE_fuaAQ@mail.gmail.com> (sfid-20111122_012257_400292_0C97F9C0)
Subject: Re: brcm80211 (with bcm4329-chip)
From: =?ISO-8859-1?Q?Thomas_Lang=E5s?= <thomas.langas@fxitech.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: Howard Harte <hharte@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 22, 2011 at 1:13 AM, Franky Lin <frankyl@broadcom.com> wrote:
> On 11/21/2011 04:00 PM, Thomas Langås wrote:
>>
>> On Tue, Nov 22, 2011 at 12:56 AM, Franky Lin<frankyl@broadcom.com>  wrote:
>> Set it to 25MHz, still same problem.
> I see. How about revert the change for enabling the debug message and give
> it a go. Can the driver function normally? (load, scan, join AP and ping).

It loads, but that's about it, it reports that the network is down.

>>> About the functional combination of .36 kernel + proprietary driver, is
>>> it a
>>> mainline kernel or an Android one?
>> Android, yes.
> You said the current kernel is from Samsung's tree, is it an Android one as
> well?

No, not Android but this one:
https://github.com/kgene/linux-samsung


Regards,
Thomas

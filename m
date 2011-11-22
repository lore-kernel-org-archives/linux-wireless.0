Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2196 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178Ab1KVANO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 19:13:14 -0500
Message-ID: <4ECAE912.8020603@broadcom.com> (sfid-20111122_011317_916591_D82BBAEF)
Date: Mon, 21 Nov 2011 16:13:06 -0800
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Thomas_Lang=E5s?= <thomas.langas@fxitech.com>
cc: "Howard Harte" <hharte@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcm80211 (with bcm4329-chip)
References: <CADrAYBnwWEaigcgQYYk6V3VEuEYyrmzJQXegKVk6TgOTPh5N8A@mail.gmail.com>
 <4ECA8908.7070304@broadcom.com> <4ECA98DB.4030608@broadcom.com>
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
In-Reply-To: <CADrAYBkL_Am57Vmo=mbJpGGZy81Tt6VoBfWt0_pb3F7wnL5Drg@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/21/2011 04:00 PM, Thomas Langås wrote:
> On Tue, Nov 22, 2011 at 12:56 AM, Franky Lin<frankyl@broadcom.com>  wrote:
>> Yes please give it a try.
>
> Set it to 25MHz, still same problem.

I see. How about revert the change for enabling the debug message and 
give it a go. Can the driver function normally? (load, scan, join AP and 
ping).

>> About the functional combination of .36 kernel + proprietary driver, is it a
>> mainline kernel or an Android one?
>
> Android, yes.

You said the current kernel is from Samsung's tree, is it an Android one 
as well?

Franky



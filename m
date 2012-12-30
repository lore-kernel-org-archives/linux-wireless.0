Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:46838 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab2L3WMp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Dec 2012 17:12:45 -0500
Received: by mail-ob0-f178.google.com with SMTP id eh20so11206482obb.9
        for <linux-wireless@vger.kernel.org>; Sun, 30 Dec 2012 14:12:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121230144046.GO18339@alittletooquiet.net>
References: <CAP9ODKqv4iaZ+cWOKJRgdvs_MJOFTTKPa=G58tWixsN1Upq3Pw@mail.gmail.com>
	<20121230144046.GO18339@alittletooquiet.net>
Date: Sun, 30 Dec 2012 20:04:35 -0200
Message-ID: <CAP9ODKrXHyv9NbEMJ3oEtFfoXQ3oMELu9BnuQwf-r_a=8yk-sA@mail.gmail.com> (sfid-20121230_232157_137802_2B0A00D9)
Subject: Re: vt6656 use
From: Otavio Salvador <otavio@ossystems.com.br>
To: Forest Bond <forest@alittletooquiet.net>
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 30, 2012 at 12:40 PM, Forest Bond
<forest@alittletooquiet.net> wrote:
> Hi Otavio,
>
> Sorry for the delayed response.

No problem; holidays, food, beer, ... all more atractive than mailing lists ;-)

> On Tue, Dec 18, 2012 at 05:53:00PM -0200, Otavio Salvador wrote:
>> I've been trying to use the adapter without success; it seems to not
>> scan the network for the available APs. I am using v3.4.22 kernel and
>> I have include the vntconfigration.dat in /etc.
>>
>> The system seem right and I see no errors in dmesg. Do you have any clue?
>>
>> Thanks in advance by any help,
>
> I have not used this driver in a few years now, so I don't think I can help.
>
> Is this on a 64 bit system?  There are known issues with 64 bit.

No it is not. It is a 32 bit system running in a Geode LX.

> Malcolm Priestley (CC'd) has been doing a lot of work on this driver lately.  I
> believe he's resolved the 64 bit issues (thanks Malcolm!).  Maybe if he has time
> he can offer some help.
>
> Otherwise, I suggest following up on the linux-wireless mailing list (also
> Cc'd).  While the linux-wireless devs in general will not be interested in
> supporting a staging driver, you might find other users that are having some
> success with the driver and can offer some advice.

Me too; let's see if someone can help with it :-)

Regards (and Happy 2013),

--
Otavio Salvador                             O.S. Systems
E-mail: otavio@ossystems.com.br  http://www.ossystems.com.br
Mobile: +55 53 9981-7854              http://projetos.ossystems.com.br

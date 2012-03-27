Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1199 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282Ab2C0Irk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 04:47:40 -0400
Message-ID: <4F717EA1.4060805@broadcom.com> (sfid-20120327_104800_933006_C8CF6094)
Date: Tue, 27 Mar 2012 10:47:29 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sgruszka@redhat.com" <sgruszka@redhat.com>,
	"jrnieder@gmail.com" <jrnieder@gmail.com>,
	"Seth Forshee" <seth.forshee@canonical.com>
Subject: Re: brcmsmac still woes, possible regression?
References: <CAKprTDELdRWtJWpmn9RMuMUYXxuaR6Cf41+jot4_fZixHQtcMw@mail.gmail.com>
 <4F6D939F.3030206@broadcom.com>
 <CAKprTDHSyh2Sv2wyY0hg4cjzWobV-zA4stY19-vB_hOBVAq5KQ@mail.gmail.com>
 <CAKprTDHpLtPu2+navGzJU9K8XX-h=Purw_q_Qs2mYn4QFEex+w@mail.gmail.com>
 <4F7035AD.1080503@broadcom.com>
 <20120326094331.GA4856@stt008.linux.site>
 <4F70409E.3090203@broadcom.com>
 <CAKprTDGdbUnXtbfmck9rtYfKeD71xSXjShW6HnxyZJ8uRZEfnQ@mail.gmail.com>
In-Reply-To: <CAKprTDGdbUnXtbfmck9rtYfKeD71xSXjShW6HnxyZJ8uRZEfnQ@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/26/2012 11:28 PM, Camaleón wrote:
> 2012/3/26 Arend van Spriel<arend@broadcom.com>:
>> On 03/26/2012 11:43 AM, Camaleón wrote:
>>>
>>> Based on a user advice, I have set the regulatory domain to ES (Spain)
>>> and I had not experienced another trace since that (the netbook was
>>> running yesterday all day long).
>>
>>
>> It all depends what channels are allowed for the ES domain. However, I am a
>> bit surprised.
>>
>>
>>> Still, I will keep my "three" eyes over it and test any pacth you
>>> consider convenient. Will comment back as soon as I get another trace
>>> or there's something worth to add :-)
>>
>>
>> Thanks.
>
> Well, I got a new trace today, I'm attaching the usual logs (dmesg and
> messages).
>
> Should I try the aforementioned patch?
>

I would appreciate it, yes.

Gr. AvS


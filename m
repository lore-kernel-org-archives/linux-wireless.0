Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48390 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab1ELOnN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 10:43:13 -0400
Received: by bwz15 with SMTP id 15so1352604bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 07:43:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimTH6ffeqTFSvaiNdQB9+wHs5EODA@mail.gmail.com>
References: <BANLkTinoAmna3mtMWY2Ai82wbGu-T9FzMQ@mail.gmail.com>
	<BANLkTi=Z=i9_WoXX=YbQtF-8imKizRPM+w@mail.gmail.com>
	<BANLkTim_uY0Di13RDHZxOpVQZaDfG3hc8A@mail.gmail.com>
	<19903.49991.848934.183819@gargle.gargle.HOWL>
	<BANLkTi=1E-Ma=N0D-gP_baSjMOvmfM-2KQ@mail.gmail.com>
	<BANLkTi=wXtCNY7TUUpfYpHux8piL09+RuQ@mail.gmail.com>
	<BANLkTiknq4jDQY2-z53QXoyHUb4b4=Oojw@mail.gmail.com>
	<BANLkTi=tZDXs=ja+YKXFVyP3FeuxmWLtuA@mail.gmail.com>
	<19908.11423.898062.510184@gargle.gargle.HOWL>
	<BANLkTin6qOChJQSmjoByS9C2_toFzHNq=A@mail.gmail.com>
	<BANLkTi=X+_cQP7RJh9Y4fPQhbJbgfNK6pQ@mail.gmail.com>
	<BANLkTinvVGrVdmku3G6hEmbv+9+nOwnZPA@mail.gmail.com>
	<19912.44045.774181.844464@gargle.gargle.HOWL>
	<19912.55320.817869.173186@gargle.gargle.HOWL>
	<19912.55857.505921.694732@gargle.gargle.HOWL>
	<BANLkTi=d7BfOBH93bDZMUDV2vhbrVtCgGA@mail.gmail.com>
	<19912.57383.634547.405469@gargle.gargle.HOWL>
	<BANLkTi=BrJPhjA5StJcktkKE7zs3Ob=iOg@mail.gmail.com>
	<19913.25619.615324.60744@gargle.gargle.HOWL>
	<BANLkTinv0XrfhDZWYpmdzSdVXZCovzhy_g@mail.gmail.com>
	<19914.42954.285439.226672@gargle.gargle.HOWL>
	<BANLkTi=uW+fVNyFJBS0fHMRAQxMKTDgaLw@mail.gmail.com>
	<BANLkTimTH6ffeqTFSvaiNdQB9+wHs5EODA@mail.gmail.com>
Date: Thu, 12 May 2011 10:42:56 -0400
Message-ID: <BANLkTika=AbksZhiykxBbS3VOFVEQY+EtQ@mail.gmail.com> (sfid-20110512_164316_964591_603C6DA5)
Subject: Re: error initializing AR7010+AR9280 Xbox 802.11n adapter
From: George Nychis <gnychis@gmail.com>
To: Sujith <m.sujith@gmail.com>
Cc: Mark Davis <marked86@gmail.com>, linux-wireless@vger.kernel.org,
	Steven <srumney@sbcglobal.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tried on a second machine with no luck still... could he get me his
exact build and firmware?

On Wed, May 11, 2011 at 11:33 AM, George Nychis <gnychis@gmail.com> wrote:
> BTW - was this with your updated firmwares you sent me, or with the
> standard 1.2 firmware?
>
>
> On Wed, May 11, 2011 at 11:22 AM, George Nychis <gnychis@gmail.com> wrote:
>> On Wed, May 11, 2011 at 11:14 AM, Sujith <m.sujith@gmail.com> wrote:
>>> George Nychis wrote:
>>>> Great, thanks Sujith!  Are we positive that the Xbox adapter is also
>>>> not UB94 now that we have seen both of these with this problem?  I am
>>>> not sure if this was speculation after seeing the initial error, or if
>>>> it is a known fact.
>>>
>>> Yes, the Xbox adapter is not based on UB94.
>>>
>>> And apparently no changes are required to use UWA-BR100, as an internal
>>> engineer was able to use ath9k_htc as is, after adding the PID/VID
>>> to the driver. So maybe the card that you have bought is different
>>> from the UWA-BR100 sample that he used. Will poke some more people and
>>> see if we're missing something.
>>>
>>
>> Maybe if we can compare lsusb of both devices to ensure that they are
>> actually the same.
>>
>> Could you have him read what the FCC ID is on the back of the stick?
>> My details are:
>>
>> IC: 409B-UWABR100
>> FCC ID: AK8UWABR100
>> ANATEL: 0010-10-4749
>>
>

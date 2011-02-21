Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:52257 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550Ab1BUOtG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 09:49:06 -0500
Received: by qyg14 with SMTP id 14so1018793qyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Feb 2011 06:49:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinYnzX_xOCCk44khXrEW_p-6uS4PP2JDTfddPk9@mail.gmail.com>
References: <AANLkTik45KLdLf5UpjPtXTNgy4Df_BupyQ3SzRr6gZgC@mail.gmail.com>
	<AANLkTin_JcEyT21dTS=Ew868HJvZQ2FVZBGXjCZn=8O_@mail.gmail.com>
	<4CBF640C.4080405@broadcom.com>
	<AANLkTinfwhjvfJU6C97SPJ8YKRqyJaCoQnAcC_uKLZa=@mail.gmail.com>
	<1287674517.2383.7.camel@dcbw.foobar.com>
	<AANLkTikLbtV5dLu+Gu=8ibi=ERPiOykN9qBL4rPKS36g@mail.gmail.com>
	<4D5EF0E9.4050908@lwfinger.net>
	<20110221095957.GA4568@redhat.com>
	<AANLkTinYnzX_xOCCk44khXrEW_p-6uS4PP2JDTfddPk9@mail.gmail.com>
Date: Mon, 21 Feb 2011 15:49:05 +0100
Message-ID: <AANLkTinQm7p7yaB14VJtBAZXdQAf3EmoqK-dH2Ofdk=8@mail.gmail.com>
Subject: Re: Request for free-distributable Broadcom's (G|LP)-PHY firmware
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Dan Williams <dcbw@redhat.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/2/21 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Mon, Feb 21, 2011 at 10:59 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> On Fri, Feb 18, 2011 at 04:21:29PM -0600, Larry Finger wrote:
>>> On 02/18/2011 03:24 PM, Rafał Miłecki wrote:
>>> >Few months later, is there any progress? Can we expect:
>>> >
>>> >1) Easier licensing of currently provided firmware (see Fedore case)
>>> >2) Firmware for LP-PHY devices
>>> >?
>>>
>>> I think we can forget this whole business. It seems that Broadcom is
>>> content with their business model, even though knowledgeable Linux
>>> users are avoiding their products like the plague.
>>
>> Broadcom will not release old firmware with redistributable license,
>> because of legal concerns, which are ridiculous for everyone except
>> them.
>>
>> http://lists.fedoraproject.org/pipermail/devel/2010-September/142893.html
>>
>> That sucks.
>>
>
> This looks like the same argument Intel is using to justify long
> delays before releasing new firmware - it needs to pass regulatory
> testing to ensure that regulatory restrictions in released FW cannot
> be circumvented. Both seem rather odd in light of Atheros's
> open-source firmware projects and general "conformant-by-default, but
> no "DRM" to prevent regulatory infringement" policy - though I seem to
> remember that Atheros acquired SDR certification, while Broadcom and
> Intel both went for regular "part 11" certification only. AFAIK the
> rules for SDRs are much more lax than those for part-11-only devices.

But Broadcom's firmware was already released, it's commonly used. Plus
they already published some N-PHY AI firmware in linux-firmware tree.
The whole situation just does not make any sense.

-- 
Rafał

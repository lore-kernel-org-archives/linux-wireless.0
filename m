Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f200.google.com ([209.85.222.200]:55769 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbZG3Fq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 01:46:29 -0400
Received: by pzk38 with SMTP id 38so320144pzk.33
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 22:46:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f7de31c0907292242s7c41daefr6ca7b3423180d005@mail.gmail.com>
References: <1248285108-10059-1-git-send-email-lrodriguez@atheros.com>
	 <f7de31c0907290313x148e2851i26df034c8e701a8c@mail.gmail.com>
	 <43e72e890907290818t62515b61p2f30278b690f22c@mail.gmail.com>
	 <f7de31c0907292242s7c41daefr6ca7b3423180d005@mail.gmail.com>
Date: Thu, 30 Jul 2009 12:46:29 +0700
Message-ID: <f7de31c0907292246h6002e9bdod9691c2f24456017@mail.gmail.com>
Subject: Re: [PATCH] wireless-regdb: TH gets 5 GHz enabled as of new
	regulatory rules
From: Phattanon Duangdara <sfalpha@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 29, 2009 at 10:18 PM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:
> Note: this e-mail is in a public mailing list.
>
> Adding Michael and David. Michael, I'd appreciate your review on this,
> if possible.
>
> Phattanon, thanks for your review of the TH document and sharing it
> with us. Please see my reply inline below.
>
> On Wed, Jul 29, 2009 at 3:13 AM, Phattanon Duangdara<sfalpha@gmail.com> wrote:
>> I corrected redgb from my knowledge.
>
> Did you see my patch? I corrected TH to be:
>
> country TH:
>        (2402 - 2482 @ 20), (N/A, 20)
>        (5170 - 5250 @ 20), (3, 17)
>        (5250 - 5330 @ 20), (3, 20), DFS
>        (5490 - 5710 @ 20), (3, 20), DFS
>        (5735 - 5835 @ 20), (3, 30)
>
>> For 5150-5350 is for Indoor Use Only.
>> Most of the regulartory
>
> What do you mean by that? Do you mean that the document refers to FCC
> and ETSI/ITU standard for regulatory purposes for some items?
>
>> refer _either_ FCC or ETSI/ITU standard, so I
>> guess that from the document 40MHz can also be used (same as US)
>> because TH regulatory mostly cover all bandwidth on 40MHz.
>
> Are you saying the Thailand document refers to FCC for max allowed
> bandwidth spacing and therefore US max bandwidth spacing should be
> used (ie allow 40 MHz width channels)?

I am not sure about this. But if equipment that comply with FCC
standard allow to use 40MHz, I think we can because, for example
Translated rule for 2.4GHz says

===

Rules for communication equipment that use 2.400-2.500 GHz band:

Communication equipment that use 2.400-2.500 GHz band must stated and
comply with
one of following standards:

2.1.2.1  EN 300 328-2  :  Electromagnetic compatibility and Radio
spectrum Matters
(ERM); Wideband Transmission systems; Data transmission
equipment operating in the 2,4 GHz ISM band and using
spread spectrum modulation techniques; Part 2: Harmonized
EN covering essential requirements under article 3.2 of R&TTE
Directive
2.1.2.2  FCC Part 15.247 :  Code of Federal Regulations (USA); Title 47
Telecommunication; Chapter 1 Federal Communications
Commission; Part 15 Radio Frequency Devices; Subpart C –
Intentional Radiators; §15.247 Operation within the bands 902–
928 MHz, 2400–2483.5 MHz, and 5725–5850 MHz

===

>
>> I corrected power but What a field before power is (that is now N/A below) ?
>
> The rules can be read as follows:
>
> (start - end @ max bandwidth spacing), (max antenna gain, max eirp)
>
>> # TH Data (2008) from
>> http://www.ratchakitcha.soc.go.th/DATA/PDF/2551/E/042/64.PDF
>> country TH:
>>        (2402 - 2472 @ 40), (N/A, 20)
>>        (5170 - 5250 @ 40), (N/A, 23), NO-OUTDOOR
>>        (5250 - 5330 @ 40), (N/A, 23), NO-OUTDOOR, DFS
>>        (5490 - 5710 @ 40), (N/A, 30), DFS
>>        (5735 - 5835 @ 30), (N/A, 30)

Opps, my typo

country TH:
       (2402 - 2472 @ 40), (N/A, 20)
       (5170 - 5250 @ 40), (N/A, 23), NO-OUTDOOR
       (5250 - 5330 @ 40), (N/A, 23), NO-OUTDOOR, DFS
       (5490 - 5710 @ 40), (N/A, 30), DFS
       (5735 - 5835 @ 40), (N/A, 30)

> Michael, does your concur with this?
>>> Summary I got from the document
>>
>> 2400-2500 MHz
>> Max Power (e.i.r.p): 100mW
>> Bandwidth: Not specified
>> Usage: Not specified
>> Ref Standard (either):
>
> Either, does that mean either FCC, or ETSI or ITU, you take a pick?
> That would seem pretty vague for regulatory purposes.
>
>> EN 300 328-2 : Electromagnetic compatibility and Radio spectrum Matters
>> (ERM); Wideband Transmission systems; Data transmission
>> equipment operating in the 2,4 GHz ISM band and using
>> spread spectrum modulation techniques; Part 2: Harmonized
>> EN covering essential requirements under article 3.2 of R&TTE
>> Directive
>
> Did this come from the TH document?

Yes. I managed to get translated documents, but for now I didn't get
any reply from NTC.

>
>> FCC Part 15.247 : Code of Federal Regulations (USA); Title 47
>> Telecommunication; Chapter 1 Federal Communications
>> Commission; Part 15 Radio Frequency Devices; Subpart C –
>> Intentional Radiators; §15.247 Operation within the bands 902–
>> 928 MHz, 2400–2483.5 MHz, and 5725–5850 MHz
>
> This too?? I ask because I see FCC mentioned.
>
>> 5150-5350 MHz
>> Max Power (e.i.r.p): 200mW, Density 10mW/MHz (0.25mW/25KHz)
>> Bandwidth: Not specified
>> Usage: Indoor applications only, DFS is must
>
> Thanks, did this came from the TH document?
>
>> Resolution 229 (WRC-03)
>> (Radio Regulations) - Use of the bands 5 150-5 250 MHz, 5 250-5 350
>> MHz and 5 470-5 725
>> MHz by the mobile service for the implementation of wireless access
>> systems including
>> radio local area networks
>>
>> Recommendation ITU-R M. 1652 (Annex 1): Dynamic
>> frequency selection (DFS) in wireless access systems including radio
>> local area networks
>> for the purpose of protecting the radiocommunication service in the 5 GHz band
>>
>> Ref Standard (either):
>>
>> ETSI EN 301 893 : Broadband Radio Access Networks (BRAN); 5 GHz high
>> performance RLAN; Harmonized EN covering essential
>> requirements of article 3.2 of the R&TTE Directive
>>
>> FCC Part 15.407 : Code of Federal Regulations (USA); Title 47
>> Telecommunications; Chapter 1 Federal Communications
>> Commission; Part 15 Radio Frequency Devices; Subpart E –
>> Unlicensed National Information Infrastructure Devices;
>> § 15.407 General technical requirements
>>
>>
>>
>> 5450-5725 MHz
>> Max Power (e.i.r.p): 1W, Density 50mW/MHz
>> Bandwidth: Not specified
>> Usage: Not specified, DFS is must
>>
>> Resolution 229 (WRC-03)
>> (Radio Regulations) - Use of the bands 5 150-5 250 MHz, 5 250-5 350
>> MHz and 5 470-5 725
>> MHz by the mobile service for the implementation of wireless access
>> systems including
>> radio local area networks
>>
>> Recommendation ITU-R M. 1652 (Annex 1): Dynamic
>> frequency selection (DFS) in wireless access systems including radio
>> local area networks
>> for the purpose of protecting the radiocommunication service in the 5 GHz band
>>
>> Ref Standard (either):
>>
>> ETSI EN 301 893 : Broadband Radio Access Networks (BRAN); 5 GHz high
>> performance RLAN; Harmonized EN covering essential
>> requirements of article 3.2 of the R&TTE Directive
>>
>> Code of Federal Regulations (USA); Title 47
>> Telecommunications; Chapter 1 Federal Communications
>> Commission; Part 15 Radio Frequency Devices; Subpart E –
>> Unlicensed National Information Infrastructure Devices;
>> § 15.407 General technical requirements
>>
>> 5725-5850 MHz
>> Max Power (e.i.r.p): 1W
>> Bandwidth: Not specified
>> Usage: Not specified
>> Ref Standard (either):
>>
>> FCC Part 15.247 : Code of Federal Regulations (USA); Title 47
>> Telecommunication; Chapter 1 Federal Communications
>> Commission; Part 15 Radio Frequency Devices; Subpart C –
>> Intentional Radiators; §15.247 Operation within the bands 902–
>> 928 MHz, 2400–2483.5 MHz, and 5725–5850 MHz
>>
>> Code of Federal Regulations (USA); Title 47
>> Telecommunications; Chapter 1 Federal Communications
>> Commission; Part 15 Radio Frequency Devices; Subpart E –
>> Unlicensed National Information Infrastructure Devices;
>> § 15.407 General technical requirements
>>
>> Phattanon,
>>
>> On Thu, Jul 23, 2009 at 12:51 AM, Luis R.
>> Rodriguez<lrodriguez@atheros.com> wrote:
>>> Phattanon Duangdara reported the National Telecommunication
>>> Commisions of Thailand has announced new regulatory rules
>>> about 5GHz for RLAN last year.
>>>
>>> I have verified this matches our documentation internally
>>> at Atheros.
>>>
>>> Reference in Thai Language:
>>> http://www.ratchakitcha.soc.go.th/DATA/PDF/2551/E/042/64.PDF
>>>
>>> Cc: Michael Green <michael.green@atheros.com>
>>> Cc: David Quan <david.quan@atheros.com>
>>> Reported-by: Phattanon Duangdara <sfalpha@gmail.com>
>>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>>> ---
>>>  db.txt |    6 +++++-
>>>  1 files changed, 5 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/db.txt b/db.txt
>>> index fad098d..01536d6 100644
>>> --- a/db.txt
>>> +++ b/db.txt
>>> @@ -534,7 +534,11 @@ country TW:
>>>        (5735 - 5815 @ 40), (3, 30)
>>>
>>>  country TH:
>>> -       (2402 - 2482 @ 40), (N/A, 20)
>>> +       (2402 - 2482 @ 20), (N/A, 20)
>>> +       (5170 - 5250 @ 20), (3, 17)
>>> +       (5250 - 5330 @ 20), (3, 20), DFS
>>> +       (5490 - 5710 @ 20), (3, 20), DFS
>>> +       (5735 - 5835 @ 20), (3, 30)
>>>
>>>  country TT:
>>>        (2402 - 2482 @ 40), (N/A, 20)
>>> --
>>> 1.6.3.3
>>>
>>>

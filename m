Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f52.google.com ([209.85.212.52]:46896 "EHLO
	mail-vw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab1IMNmz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 09:42:55 -0400
Received: by vws16 with SMTP id 16so1002681vws.11
        for <linux-wireless@vger.kernel.org>; Tue, 13 Sep 2011 06:42:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110913132844.GB11772@tuxdriver.com>
References: <CAC9WiBj0A54_R3NszGBEhzMAiZzL0NBmickE88avp0NDGHyjpg@mail.gmail.com>
	<CACna6rwQ60viPGssWzBzgtVGBq1xu+AOxb0fqfRq4NaJFcmP=w@mail.gmail.com>
	<CAC9WiBi5L7uV=OzYBKs=sdjRr4Xykcd2USQPtPhCsSBLdpW-6g@mail.gmail.com>
	<20110913132844.GB11772@tuxdriver.com>
Date: Tue, 13 Sep 2011 15:37:12 +0200
Message-ID: <CAC9WiBjOj9+HmprcdKhfj5Y=SpNoKQj=wZfBJzR7fpx9OA+1hQ@mail.gmail.com> (sfid-20110913_154258_094594_2107B4D7)
Subject: Re: About the patch: "staging: brcm80211: only enable brcmsmac if
 bcma is not set"
From: Francis Moreau <francis.moro@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 13, 2011 at 3:28 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Tue, Sep 13, 2011 at 09:03:13AM +0200, Francis Moreau wrote:
>> 2011/9/12 Rafał Miłecki <zajec5@gmail.com>:
>
>> > The real solution is to add bcma driver support in brcmsmac and ssb
>> > driver support in brcmfmac. Then you can always use bcma and:
>> > 1) If b43 will load and detect unsupported PHY, it will release the BCMA's core
>> > 2) brcmsmac will be loaded to let it support the core
>> >
>>
>> Thanks for the description.
>>
>> But what should be done for the time being (3.1-rc5) ?
>
> Turn-off CONFIG_B43_BCMA.
>

Does the b43/bcma driver support some cards that the brcmsmac one doesn't ?

-- 
Francis

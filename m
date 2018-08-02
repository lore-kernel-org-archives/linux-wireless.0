Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55010 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbeHBTMa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Aug 2018 15:12:30 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v3 00/14] Add mt76x0 driver
References: <1533040864-9026-1-git-send-email-sgruszka@redhat.com>
        <87y3dqzga9.fsf@purkki.adurom.net> <20180801082508.GA4526@redhat.com>
        <20180801084056.GB4794@localhost.localdomain>
Date: Thu, 02 Aug 2018 20:20:12 +0300
In-Reply-To: <20180801084056.GB4794@localhost.localdomain> (Lorenzo Bianconi's
        message of "Wed, 1 Aug 2018 10:40:57 +0200")
Message-ID: <87k1p87kj7.fsf@kamboji.qca.qualcomm.com> (sfid-20180802_192030_225222_2BBA754A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

> On Aug 01, Stanislaw Gruszka wrote:
>> On Wed, Aug 01, 2018 at 10:39:58AM +0300, Kalle Valo wrote:
>> > Stanislaw Gruszka <sgruszka@redhat.com> writes:
>> > 
>> > > Add mt76x0 driver for MT7610U based USB dongles. Currently driver
>> > > support only STA mode.
>> > >
>> > > mt76x0 is based on Jakub's mt7601u driver already included
>> > > in the kernel. I would like the driver be integrated as part
>> > > of mt76 (instead of separate driver in mediatek dir like mt7601u)
>> > > to utilize mt76 code for adding support for MT76x0 PCIe devices
>> > > in further development.
>> > 
>> > So what's the future for mt7601u, are we going to delete it? What's
>> > Jakub's opinion about all this? And what's the delta featurewise between
>> > mt7601u and this driver? Which one will be loaded by default?
>> 
>> mt7601u is driver for different chip: MT7601. This driver if for MT7610
>> chip. There are lot of similarities between the drivers, but there are
>> bunch of differences too. And in the future development of mt76x0, due
>> to integration into mt76 and mt76x2u and adding support for PCIe chips,
>> the differences against mt7601u will be much be bigger.
>> 
>> > Also I noticed that mt76 is missing an entry in MAINTAINERS file? Could
>> > someone send a separate patch to add that, please?
>> 
>> The question is if Felix would like to be the maintainer? Otherwise who would
>> want to do this job? I think the best option would be to get some
>> commitment from Mediatek if that possible, maybe Sean Wang could aggree
>> to be the maintainer ? :-)
>
> Maybe add multiple maintainers? I think the best option is Felix (if he agrees)
> since he started the work and he has more experience/knowledge of the code

Yeah, multiple maintainers would also work. Another option is to have
one maintainer and one or more reviewers:

        R: Designated reviewer: FullName <address@domain>
           These reviewers should be CCed on patches.

And even better if Mediatek could actively join the development and
review.

-- 
Kalle Valo

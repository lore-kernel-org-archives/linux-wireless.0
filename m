Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2681 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab3DEHXe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 03:23:34 -0400
Message-ID: <515E7BE7.6040909@broadcom.com> (sfid-20130405_092353_189363_13DCCD0C)
Date: Fri, 5 Apr 2013 09:23:19 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Julian Calaby" <julian.calaby@gmail.com>
cc: "Wang YanQing" <udknight@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib80211: make lib80211 can be enabled
 independently
References: <20130404160130.GA2577@udknight>
 <CAGRGNgXj7mSF0Fgyjek4Xcc34N26WHtt4HMmHk7DOopaEPrYFw@mail.gmail.com>
In-Reply-To: <CAGRGNgXj7mSF0Fgyjek4Xcc34N26WHtt4HMmHk7DOopaEPrYFw@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/05/2013 01:51 AM, Julian Calaby wrote:
> Hi Wang,
>
> On Fri, Apr 5, 2013 at 3:01 AM, Wang YanQing <udknight@gmail.com> wrote:
>>
>> Current we can only enable lib80211 by enable a driver
>> in tree use it which will select it, but some out tree's
>> drivers also use it, so I think it has sense to make lib80211
>> can be enabled independently.
>
> Just as a bit of explanation for Johannes' NACK:
>
> 3. I believe that the in-tree brcmsmac driver already supports the
> Broadcom card you reference.

That is correct.

Gr. AvS


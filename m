Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:61325 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab3GHUUj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 16:20:39 -0400
Received: by mail-lb0-f170.google.com with SMTP id t13so4126010lbd.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jul 2013 13:20:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABPxzYLD3xp9vyTA42PsCdNo1qAm4+X4OrqFTN70-aGvO52FeQ@mail.gmail.com>
References: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
 <1372899889-19183-43-git-send-email-mcgrof@do-not-panic.com>
 <51D5BD9D.5020604@broadcom.com> <CABPxzYLD3xp9vyTA42PsCdNo1qAm4+X4OrqFTN70-aGvO52FeQ@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 8 Jul 2013 13:20:16 -0700
Message-ID: <CAB=NE6UvN25jbyVgGzbfdniJY9chxhr1FRDyF89Y+AEGyDBnkg@mail.gmail.com> (sfid-20130708_222042_821100_E616FDEB)
Subject: Re: [RFC 42/53] wireless-regdb: ID, Indonesia - enable 5 GHz and VHT80
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 4, 2013 at 12:29 PM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> On Thu, Jul 4, 2013 at 11:53 PM, Arend van Spriel <arend@broadcom.com> wrote:
>>
>> On 07/04/2013 03:04 AM, Luis R. Rodriguez wrote:
>>>
>>> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>>>
>>> Pursuant to:
>>>
>>> http://www.postel.go.id/content/ID/regulasi/standardisasi/kepdir/bwa%205,8%20ghz.pdf,
>>>
>>> provide a 5GHz rule for Indonesian regulatory domain. QCA has
>>> also verified VHT80 can be enabled. Patch originally posted by
>>> Paul Stewart <pstew@chromium.org>, I just modified to enable 80 MHz
>>> bandwidth.
>>
>>
>> Hi Luis,
>>
>> Is it just me or did you make a typo. Should '@ 20' be '@ 80' ?

Indeed, typo, I'll fix in my next iteration!

> But as per the document shared above the maximum BW allowed is 20MHz only, no?
> So is the VHT80 tested by QCA compliant to the reg rules?

Yes it is.

  Luis

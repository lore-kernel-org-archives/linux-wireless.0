Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34364 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbbI1U1B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 16:27:01 -0400
Received: by wicfx3 with SMTP id fx3so121721021wic.1
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2015 13:27:00 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2087\))
Subject: Re: [wireless-regdb] wireless-regdb: Update regulatory rules for South Africa (ZA) on 5GHz
From: =?utf-8?Q?Karl_M=C3=B6ller?= <karl@excors.net>
In-Reply-To: <1443462165.2401.7.camel@sipsolutions.net>
Date: Mon, 28 Sep 2015 22:26:52 +0200
Cc: Seth Forshee <seth.forshee@canonical.com>,
	wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Message-Id: <D78DAA74-CFD9-4D12-81F0-E994924D401F@excors.net> (sfid-20150928_222705_516292_F9BFF170)
References: <9BEBB87E-EA6D-4219-ADC5-40C1E19DA5DA@excors.net> <1443426260.2401.2.camel@sipsolutions.net> <20150928160741.GA25936@ubuntu-hedt> <1443462165.2401.7.camel@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is an older draft document, dated end 2014 directly from the regulator (ICASA):

http://www.icasa.org.za/Portals/0/Regulations/Working%20Docmuents/Radio%20Frequency%20Spectrum%20Regulations/DraftRevRadioFreq.pdf

Notice on page end 80 / top 81 that it lists:

"DFS & Transmitter Power Control Obligatory” for the band in question, which is now deleted in the final document published in March this year.

Regards
Karl

> On 28 Sep 2015, at 7:42 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> On Mon, 2015-09-28 at 11:07 -0500, Seth Forshee wrote:
>> On Mon, Sep 28, 2015 at 09:44:20AM +0200, Johannes Berg wrote:
>>> 
>>>> The bands don’t quite match up and DFS/TPC is (apparently) not 
>>>> required for 5470 - 5725. More importantly, the max transmitted 
>>>> power
>>>> seems to be 1W/30dBm e.i.r.p and not 27dBm.
>>> 
>>> Without checking now, just a note: we sometimes have lower limits 
>>> here
>>> due to spectral power density, indoor/outdoor or TPC requirements.
>> 
>> One of the documents says that the TPC requirement for that range was
>> lifted in March 2015, so if it was lowered for TPC then we may be 
>> able to bump it up to 30 dBm.
>> 
> 
> That's very well possible then - the typical TCP requirement is "1/2 of
> the power w/o TPC", which would match the 3dB
> 
> johannes


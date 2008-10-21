Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:15617 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbYJUVx5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 17:53:57 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2695871wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2008 14:53:55 -0700 (PDT)
Message-ID: <1ba2fa240810211453y40739183v84999364c89886ee@mail.gmail.com> (sfid-20081021_235402_098593_9D18BD2F)
Date: Tue, 21 Oct 2008 23:53:55 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: New iwlwifi 3945 uCode available
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"reinette chatre" <reinette.chatre@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081021213814.GM17268@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1224613633.10863.43.camel@rc-desk>
	 <1224624324.28639.9.camel@johannes.berg>
	 <1ba2fa240810211433q2e7a13b2p45cb8d38a74393c9@mail.gmail.com>
	 <1224624899.28639.17.camel@johannes.berg>
	 <20081021213814.GM17268@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 21, 2008 at 11:38 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Tue, Oct 21, 2008 at 11:34:59PM +0200, Johannes Berg wrote:
>> On Tue, 2008-10-21 at 23:33 +0200, Tomas Winkler wrote:
>> > On Tue, Oct 21, 2008 at 11:25 PM, Johannes Berg
>> > <johannes@sipsolutions.net> wrote:
>> > > On Tue, 2008-10-21 at 11:27 -0700, reinette chatre wrote:
>> > >> Two new versions of 3945 uCode is now available for download from
>> > >> http://intellinuxwireless.org/?n=Downloads. Two versions are available
>> > >> as we have updated the API version of the uCode and included pending
>> > >> fixes in both API versions.
>> > >>
>> > >> Version 15.28.1.8 supports API v1 and can be used with most current 3945
>> > >> drivers. Version 15.28.2.8 (API v2) is required when you start using the
>> > >> latest 3945 driver from wireless-testing at the time it includes the
>> > >> patch "iwl3945 : Fix a-band association for passive channels".
>> > >
>> > > Can you make the driver work with the old ucode? We even do that for
>> > > drivers where we don't control the ucode like b43...
>> >
>> > What for?
>>
>> Well, so that installing a new kernel doesn't suddenly break your
>> network connection and ability to download the firmware, for instance.
>> If you want more arguments you can go read all the "b43 sucks" threads
>> about it.
>
> Johnannes has a point, that is a lot nicer to users...

Maybe, but it will complicate the code beyond good taste to just
satisfy the single moment when kernel is upgraded. I don't mean in
general I mean in this particular case when API changes.
Anyhow a good distro shell deal with this in packaging dependencies
and normal person will keep old kernel around when compiling new one.
Both ucodes can be present on the file system at the same time  so I
hope the risk is low.
Tomas

>
> --
> John W. Linville                Linux should be at the core
> linville@tuxdriver.com                  of your literate lifestyle.
>

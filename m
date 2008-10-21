Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:36513 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbYJUWMQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 18:12:16 -0400
Subject: Re: New iwlwifi 3945 uCode available
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	reinette chatre <reinette.chatre@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240810211453y40739183v84999364c89886ee@mail.gmail.com>
References: <1224613633.10863.43.camel@rc-desk>
	 <1224624324.28639.9.camel@johannes.berg>
	 <1ba2fa240810211433q2e7a13b2p45cb8d38a74393c9@mail.gmail.com>
	 <1224624899.28639.17.camel@johannes.berg>
	 <20081021213814.GM17268@tuxdriver.com>
	 <1ba2fa240810211453y40739183v84999364c89886ee@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 00:13:07 +0200
Message-Id: <1224627187.9386.103.camel@californication> (sfid-20081022_001222_298607_5CBEEE84)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tomas,

> >> > > On Tue, 2008-10-21 at 11:27 -0700, reinette chatre wrote:
> >> > >> Two new versions of 3945 uCode is now available for download from
> >> > >> http://intellinuxwireless.org/?n=Downloads. Two versions are available
> >> > >> as we have updated the API version of the uCode and included pending
> >> > >> fixes in both API versions.
> >> > >>
> >> > >> Version 15.28.1.8 supports API v1 and can be used with most current 3945
> >> > >> drivers. Version 15.28.2.8 (API v2) is required when you start using the
> >> > >> latest 3945 driver from wireless-testing at the time it includes the
> >> > >> patch "iwl3945 : Fix a-band association for passive channels".
> >> > >
> >> > > Can you make the driver work with the old ucode? We even do that for
> >> > > drivers where we don't control the ucode like b43...
> >> >
> >> > What for?
> >>
> >> Well, so that installing a new kernel doesn't suddenly break your
> >> network connection and ability to download the firmware, for instance.
> >> If you want more arguments you can go read all the "b43 sucks" threads
> >> about it.
> >
> > Johnannes has a point, that is a lot nicer to users...
> 
> Maybe, but it will complicate the code beyond good taste to just
> satisfy the single moment when kernel is upgraded. I don't mean in
> general I mean in this particular case when API changes.
> Anyhow a good distro shell deal with this in packaging dependencies
> and normal person will keep old kernel around when compiling new one.
> Both ucodes can be present on the file system at the same time  so I
> hope the risk is low.

it is the same argument as for everything else. We should be able to run
a new kernel with old userspace.

Regards

Marcel



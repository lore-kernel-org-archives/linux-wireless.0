Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63789 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965115Ab2CMKWX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 06:22:23 -0400
Received: by iagz16 with SMTP id z16so595544iag.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Mar 2012 03:22:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120313005744.GA30312@srcf.ucam.org>
References: <4F5E7031.4000401@candelatech.com> <201203122332.16325.chunkeey@googlemail.com>
 <4F5E7A81.8090605@candelatech.com> <CAB=NE6WeB8X51xdEOT3-XjyBBVrwdMSMYmFOTbuH3pKzCM8jyw@mail.gmail.com>
 <20120313005744.GA30312@srcf.ucam.org>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 12 Mar 2012 18:11:09 -0700
Message-ID: <CAB=NE6WvuZLAt86R8fn+OzQybdSkU0iPoHr51p_qe1_PkMfUcQ@mail.gmail.com> (sfid-20120313_112227_698615_DD70E8EA)
Subject: Re: Hacking PCI-ids to allow Atheros NIC into Lenovo laptop.
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ben Greear <greearb@candelatech.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 12, 2012 at 5:57 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Mon, Mar 12, 2012 at 05:53:03PM -0700, Luis R. Rodriguez wrote:
>
>> I might as well chime in to explain the long story. If we figure out a
>> way to ensure we can always get the antenna gain uniformly across
>> different systems and expose this to the OS I suspect we can convince
>> some OEMs this would be a better solution than simply restricting
>> devices. I looked a the newer generation of dmidecode (its not called
>> DMI, its something else now) thingy but saw no one yet had added
>> 802.11 specifically, perhaps it may be good to consider it in the
>> future for this. that's as far as I got from trying to kill this
>> concern.
>
> Exposing it as either an smbios table or in ACPI somewhere would be the
> two most typical methods for doing this. It's easy to spec an ACPI table
> for it if you think there'd be any vendor interest.

Better than what we have today, no alternative proposal.

  Luis

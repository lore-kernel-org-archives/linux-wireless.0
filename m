Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:35551 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275Ab2CMA5u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 20:57:50 -0400
Date: Tue, 13 Mar 2012 00:57:44 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: Ben Greear <greearb@candelatech.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Hacking PCI-ids to allow Atheros NIC into Lenovo laptop.
Message-ID: <20120313005744.GA30312@srcf.ucam.org> (sfid-20120313_015802_410058_326CB702)
References: <4F5E7031.4000401@candelatech.com>
 <201203122332.16325.chunkeey@googlemail.com>
 <4F5E7A81.8090605@candelatech.com>
 <CAB=NE6WeB8X51xdEOT3-XjyBBVrwdMSMYmFOTbuH3pKzCM8jyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB=NE6WeB8X51xdEOT3-XjyBBVrwdMSMYmFOTbuH3pKzCM8jyw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 12, 2012 at 05:53:03PM -0700, Luis R. Rodriguez wrote:

> I might as well chime in to explain the long story. If we figure out a
> way to ensure we can always get the antenna gain uniformly across
> different systems and expose this to the OS I suspect we can convince
> some OEMs this would be a better solution than simply restricting
> devices. I looked a the newer generation of dmidecode (its not called
> DMI, its something else now) thingy but saw no one yet had added
> 802.11 specifically, perhaps it may be good to consider it in the
> future for this. that's as far as I got from trying to kill this
> concern.

Exposing it as either an smbios table or in ACPI somewhere would be the 
two most typical methods for doing this. It's easy to spec an ACPI table 
for it if you think there'd be any vendor interest.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

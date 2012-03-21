Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:52599 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030775Ab2CULPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2012 07:15:21 -0400
Date: Wed, 21 Mar 2012 11:15:13 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Adrian Chadd <adrian@freebsd.org>
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>,
	Ben Greear <greearb@candelatech.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Hacking PCI-ids to allow Atheros NIC into Lenovo laptop.
Message-ID: <20120321111513.GA26854@srcf.ucam.org> (sfid-20120321_121525_278612_587A9B30)
References: <4F5E7031.4000401@candelatech.com>
 <201203122332.16325.chunkeey@googlemail.com>
 <4F5E7A81.8090605@candelatech.com>
 <CAB=NE6WeB8X51xdEOT3-XjyBBVrwdMSMYmFOTbuH3pKzCM8jyw@mail.gmail.com>
 <20120313005744.GA30312@srcf.ucam.org>
 <CAB=NE6WvuZLAt86R8fn+OzQybdSkU0iPoHr51p_qe1_PkMfUcQ@mail.gmail.com>
 <CAJ-Vmok+_suTznXcAJ4tdGo3npFvtW+PiqQMQqqH3JN70aX3Qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ-Vmok+_suTznXcAJ4tdGo3npFvtW+PiqQMQqqH3JN70aX3Qg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 20, 2012 at 10:01:05PM -0700, Adrian Chadd wrote:
> On 12 March 2012 18:11, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> 
> >> Exposing it as either an smbios table or in ACPI somewhere would be the
> >> two most typical methods for doing this. It's easy to spec an ACPI table
> >> for it if you think there'd be any vendor interest.
> >
> > Better than what we have today, no alternative proposal.
> 
> Is there any current "vendor space" in ACPI that we can write to and
> leverage as a kind of example test case?

Not really. In theory the ACPI namespace is only usable if you've pushed 
something through the ACPI process - in practice, grabbing a table name 
first and asking questions later tends to work fine.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

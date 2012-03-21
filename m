Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42758 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab2CUFBF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2012 01:01:05 -0400
Received: by pbcun15 with SMTP id un15so532852pbc.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Mar 2012 22:01:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6WvuZLAt86R8fn+OzQybdSkU0iPoHr51p_qe1_PkMfUcQ@mail.gmail.com>
References: <4F5E7031.4000401@candelatech.com>
	<201203122332.16325.chunkeey@googlemail.com>
	<4F5E7A81.8090605@candelatech.com>
	<CAB=NE6WeB8X51xdEOT3-XjyBBVrwdMSMYmFOTbuH3pKzCM8jyw@mail.gmail.com>
	<20120313005744.GA30312@srcf.ucam.org>
	<CAB=NE6WvuZLAt86R8fn+OzQybdSkU0iPoHr51p_qe1_PkMfUcQ@mail.gmail.com>
Date: Tue, 20 Mar 2012 22:01:05 -0700
Message-ID: <CAJ-Vmok+_suTznXcAJ4tdGo3npFvtW+PiqQMQqqH3JN70aX3Qg@mail.gmail.com> (sfid-20120321_060111_259150_20BCE62E)
Subject: Re: Hacking PCI-ids to allow Atheros NIC into Lenovo laptop.
From: Adrian Chadd <adrian@freebsd.org>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	Ben Greear <greearb@candelatech.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 March 2012 18:11, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:

>> Exposing it as either an smbios table or in ACPI somewhere would be the
>> two most typical methods for doing this. It's easy to spec an ACPI table
>> for it if you think there'd be any vendor interest.
>
> Better than what we have today, no alternative proposal.

Is there any current "vendor space" in ACPI that we can write to and
leverage as a kind of example test case?



Adrian

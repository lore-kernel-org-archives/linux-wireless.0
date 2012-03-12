Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38382 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab2CLWRb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 18:17:31 -0400
Received: by iagz16 with SMTP id z16so7454871iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Mar 2012 15:17:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F5E7031.4000401@candelatech.com>
References: <4F5E7031.4000401@candelatech.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 13 Mar 2012 09:16:46 +1100
Message-ID: <CAGRGNgWLJ-Xf7WaGK-xNikfwpP-=hE1jm=odfSj_r-rmbRc5zQ@mail.gmail.com> (sfid-20120312_231735_224084_4914B474)
Subject: Re: Hacking PCI-ids to allow Atheros NIC into Lenovo laptop.
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

On Tue, Mar 13, 2012 at 08:52, Ben Greear <greearb@candelatech.com> wrote:
> It seems we bought a Lenovo laptop that has a BIOS lock where it will only
> support certain wifi NICs based on the pci-id.  It came with an Intel
> NIC, so at least that ID must work...

This is standard with Lenovo (and I believe this originated back when
IBM was building the machines) as it's their method of ensuring some
form of compliance - i.e. they guarantee that it complies with

More details here:

http://www.thinkwiki.org/wiki/Problem_with_unauthorized_MiniPCI_network_card

> One way around this might be to over-write the pci-id of an Atheros NIC
> in it's non-volatile storage to make it look like an Intel, at least until
> the kernel boots.

That is one of the solutions discussed on that page, it also discusses
a few others with varying amounts of success.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/

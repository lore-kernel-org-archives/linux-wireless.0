Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57458 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab2CMDOK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 23:14:10 -0400
Received: by iagz16 with SMTP id z16so149177iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Mar 2012 20:14:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F5E9BAD.6040505@candelatech.com>
References: <4F5E7031.4000401@candelatech.com> <201203122332.16325.chunkeey@googlemail.com>
 <4F5E7A81.8090605@candelatech.com> <CAB=NE6WeB8X51xdEOT3-XjyBBVrwdMSMYmFOTbuH3pKzCM8jyw@mail.gmail.com>
 <4F5E9BAD.6040505@candelatech.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 13 Mar 2012 14:13:49 +1100
Message-ID: <CAGRGNgWDGE_0S7hJDDwAupV6nB7v7TSPOYts-3JLY-_sCA-EJA@mail.gmail.com> (sfid-20120313_041414_615376_79970BDE)
Subject: Re: Hacking PCI-ids to allow Atheros NIC into Lenovo laptop.
To: Ben Greear <greearb@candelatech.com>
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

On Tue, Mar 13, 2012 at 11:58, Ben Greear <greearb@candelatech.com> wrote:
> Seems like laptop vendors are just being lame.  Why can normal PCs
> get away with no restrictions but somehow laptop makers have to do this??

>From what I've read, the issue isn't the card or regulatory itself,
it's the antennae.

In a desktop situation, you have a card with an detachable antenna,
and the card / antenna unit can be confirmed to comply with whatever
regulations are in effect.

In a laptop, the antennae are usually part of the laptop body, and
only the card itself is replaceable, so the manufacturer is locking
out cards that it has not tested with the built-in antennae.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/

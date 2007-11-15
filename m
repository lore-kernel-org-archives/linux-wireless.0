Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4625 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757082AbXKOBVA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 20:21:00 -0500
Date: Wed, 14 Nov 2007 20:20:35 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Marcus Better <marcus@better.se>
Cc: Florian Lohoff <flo@rfc822.org>, linux-wireless@vger.kernel.org
Subject: Re: rt2x00/rt2500 PCI unresponsive / sluggish response
Message-ID: <20071115012035.GA15039@tuxdriver.com> (sfid-20071115_012108_352421_DC2A583E)
References: <20071111102315.GC10486@paradigm.rfc822.org> <8e6f94720711121459j56f640abid03cb2a1eca319c2@mail.gmail.com> <20071113192330.GA19601@paradigm.rfc822.org> <fhedc4$5l9$1@ger.gmane.org> <20071114121753.GB30575@paradigm.rfc822.org> <473AE7C4.40701@better.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <473AE7C4.40701@better.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 14, 2007 at 01:19:16PM +0100, Marcus Better wrote:
> Florian Lohoff skrev:
> >As you mention a quite young tree (2.6.23-rc3) - did you try bisecting
> >it on the wireless-dev tree?
> 
> I don't think that's possible since the tree was rebased.

You can try using the wireless-legacy tree, specifically the
wireless-dev-2007-09-24 branch.

John
-- 
John W. Linville
linville@tuxdriver.com

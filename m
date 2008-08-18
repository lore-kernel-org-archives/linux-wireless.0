Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:57642 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbYHRIRH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2008 04:17:07 -0400
Received: by fk-out-0910.google.com with SMTP id 18so2091017fkq.5
        for <linux-wireless@vger.kernel.org>; Mon, 18 Aug 2008 01:17:06 -0700 (PDT)
Message-ID: <1ba2fa240808180117n37e412cbx1b11c50914dd5710@mail.gmail.com> (sfid-20080818_101711_641518_723F9F9D)
Date: Mon, 18 Aug 2008 11:17:06 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Russell Senior" <seniorr@aracnet.com>
Subject: Re: [ipw3945-devel] Few questions about the wireless stack
Cc: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <86r68magid.fsf@coulee.tdb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48A07709.80306@gmail.com> <48A206A0.6020709@gmail.com>
	 <48A224E3.90307@telenet.be> <861w0mbwxd.fsf@coulee.tdb.com>
	 <1ba2fa240808180046k2d281a0fqc2617eb75092787e@mail.gmail.com>
	 <86r68magid.fsf@coulee.tdb.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 18, 2008 at 11:12 AM, Russell Senior <seniorr@aracnet.com> wrote:
>>>>>> "Tomas" == Tomas Winkler <tomasw@gmail.com> writes:
>
> Russell> FWIW, the PC Engines Alix.6* boards has or will include a
> Russell> miniPCI express slot.
>
> Russell> http://pcengines.ch/alix.htm
>
> Russell> As someone building stuff from these and similar boards, I
> Russell> appreciate having options.
>
> Tomas> 3945 runs on mini PCIe ___wx__ bus not regular miniPCIe. There
> Tomas> is no real problem that 3945 will run in AP/master mode I just
> Tomas> don't think than anyone will make embedded device from it.
>
> Okay.  I have no idea what difference there is between wx bus and
> regular mini PCI express.

wx runs of 1/3 of frequency of regular pcie bus. It was one time
adventure and further product uses regular pcie bus.
Tomas

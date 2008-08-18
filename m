Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:55430 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbYHRHqx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2008 03:46:53 -0400
Received: by fk-out-0910.google.com with SMTP id 18so2084272fkq.5
        for <linux-wireless@vger.kernel.org>; Mon, 18 Aug 2008 00:46:51 -0700 (PDT)
Message-ID: <1ba2fa240808180046k2d281a0fqc2617eb75092787e@mail.gmail.com> (sfid-20080818_094657_622956_5A756A9E)
Date: Mon, 18 Aug 2008 10:46:51 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Russell Senior" <seniorr@aracnet.com>
Subject: Re: [ipw3945-devel] Few questions about the wireless stack
Cc: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <861w0mbwxd.fsf@coulee.tdb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48A07709.80306@gmail.com> <48A206A0.6020709@gmail.com>
	 <48A224E3.90307@telenet.be> <861w0mbwxd.fsf@coulee.tdb.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 18, 2008 at 10:32 AM, Russell Senior <seniorr@aracnet.com> wrote:
>>>>>> "Ian" == Ian Schram <ischram@telenet.be> writes:
>
> Ian> Last i can remember about the subject was Tomas some months ago.
>
> Ian> iirc the statement was something similar to: - 3945 is a mini
> Ian> PCIe card, and hence not deployed in embedded? devices, therefore
> Ian> master mode support isn't planned for 3945 - patches are welcome
>
> FWIW, the PC Engines Alix.6* boards has or will include a miniPCI
> express slot.
>
>  http://pcengines.ch/alix.htm
>
> As someone building stuff from these and similar boards, I appreciate
> having options.
>
3945 runs on  mini PCIe ___wx__ bus not regular miniPCIe. There is no
real problem that 3945 will run in AP/master mode  I just don't think
than anyone will make embedded device from it.

Tomas

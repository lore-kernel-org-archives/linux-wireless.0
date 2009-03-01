Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:63968 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753904AbZCAT3t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2009 14:29:49 -0500
Message-ID: <49AAE22A.3080808@lwfinger.net> (sfid-20090301_202952_882942_715A272C)
Date: Sun, 01 Mar 2009 13:29:46 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8187 performance diagnostics
References: <35879.82.152.175.172.1234904444.squirrel@www.phantomjinx.co.uk>    <499B27A4.30708@lwfinger.net>    <42781.82.152.175.172.1234911183.squirrel@www.phantomjinx.co.uk>    <499B4526.1030705@lwfinger.net>    <44177.82.152.175.172.1235088928.squirrel@www.phantomjinx.co.uk>    <499E1826.8040903@lwfinger.net>    <56183.82.152.175.172.1235173364.squirrel@www.phantomjinx.co.uk>    <499F4763.70106@lwfinger.net> <60836.82.152.175.172.1235929727.squirrel@www.phantomjinx.co.uk>
In-Reply-To: <60836.82.152.175.172.1235929727.squirrel@www.phantomjinx.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

P.G. Richardson wrote:
> Is there anything I can do to help improve this situation? These results
> seems to rule out hardware in favour of being driver related. Are there
> other tests I could perform to determine where the fragility lies?
> 
> Any thoughts, let me know.

OK, the Windows driver is better than the Linux one. Unfortunately, source is
not available.

You can check what we did when the RTL8187B was implemented. To do that, you
need to download the Realtek vendor-written Linux driver and check what they do
against what is in the current in-kernel driver. The critical areas will likely
be associated with power settings for the radio. Be aware that their code is
quite difficult to read as it has multiple conditional compilations that are
hard to keep straight.

I will be happy to test any improvements that you suggest.

Larry

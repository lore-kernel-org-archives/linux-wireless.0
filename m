Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:37870 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbZBLIAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 03:00:30 -0500
Received: by bwz5 with SMTP id 5so794348bwz.13
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 00:00:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090212042217.b05e83b4.cjsthompson@gmail.com>
References: <20090211211707.d5e71ddb.cjsthompson@gmail.com>
	 <200902112332.53480.IvDoorn@gmail.com>
	 <3ace41890902111451n6c9cbdc4me410609479b1ac4f@mail.gmail.com>
	 <20090212042217.b05e83b4.cjsthompson@gmail.com>
Date: Thu, 12 Feb 2009 09:00:27 +0100
Message-ID: <a32f33a40902120000g1e95df1eq8a221ddc539f351c@mail.gmail.com> (sfid-20090212_090034_601310_07EE4595)
Subject: Re: Sitecom WL-608 USB WiFi
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: "Christoph .J Thompson" <cjsthompson@gmail.com>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 12, 2009 at 4:22 AM, Christoph .J Thompson
<cjsthompson@gmail.com> wrote:
> Further research suggest this WiFi dongle has the RT2870 chipset, it works with the RaLink driver once the id has been added to it.

Hmm thats weird, I couldn't find the reference that it is a 11n device. :S
Anyway, I'll add the USB ID to rt2800usb.

Ivo

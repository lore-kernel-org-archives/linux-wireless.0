Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.191]:42261 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765362AbXHGQVD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 12:21:03 -0400
Received: by rv-out-0910.google.com with SMTP id k20so1433721rvb
        for <linux-wireless@vger.kernel.org>; Tue, 07 Aug 2007 09:21:03 -0700 (PDT)
Message-ID: <a728f9f90708070921x13c1a9fem8f7bbf3fe77756d@mail.gmail.com>
Date: Tue, 7 Aug 2007 12:21:02 -0400
From: "Alex Deucher" <alexdeucher@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Marvell pci wifi chips
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is anyone working on a driver for the marvell pci libertas chips
(8335, 8300, 8310, etc.) or know of someone who is?  I've got several
of these cards not doing anything at the moment if someone is
interested in one.  It seems there are several drivers floating
around:

- mrv8k driver (http://www.saillard.org/linux/mrv8k/)
- openbsd malo driver (http://www.openbsd.org/cgi-bin/man.cgi?query=malo)
- marvell GPL driver (http://johannes.sipsolutions.net/files/marvell.tar.bz2)

Reading through the linux-wireless archive, several people seemed to
indicate there was work going on, but I have not been able to find any
information on that other than Holger's CF libertas integration.  I
and others have asked before, but there seems to be some confusion as
to the whole libertas line and their relative compatibility.  Just
curious.

Thanks,

Alex

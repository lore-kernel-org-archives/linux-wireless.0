Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:37735 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab1KVNyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 08:54:45 -0500
Date: Tue, 22 Nov 2011 08:54:12 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux SCSI List <linux-scsi@vger.kernel.org>,
	Linux ACPI <linux-acpi@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	DRI <dri-devel@lists.freedesktop.org>,
	Florian Mickler <florian@mickler.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux PM List <linux-pm@lists.linux-foundation.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: 3.2-rc2+: Reported regressions from 3.0 and 3.1
Message-ID: <20111122135412.GA29905@phenom.dumpdata.com> (sfid-20111122_145509_877771_1C449E47)
References: <lx6sezwGldO.A.IhF.UBpWOB@chimera>
 <201111212249.31196.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201111212249.31196.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Subject    : Regression in 3.1 causes Xen to use wrong idle routine
> Submitter  : Stefan Bader <stefan.bader@canonical.com>
> Date       : 2011-10-26 10:24
> Message-ID : 4EA7DFD1.9060608@canonical.com
> References : http://marc.info/?l=linux-acpi&m=131962467924564&w=2

The patch mentioned in http://mid.gmane.org/20111115144004.GE22675@phenom.dumpdata.com 
should do it. But the patch needs an Ack from ACPI/x86 folks.

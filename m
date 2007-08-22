Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ftp.linux-mips.org ([194.74.144.162]:57242 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762977AbXHWM22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 08:28:28 -0400
Received: from localhost.localdomain ([127.0.0.1]:7110 "EHLO
	dl5rb.ham-radio-op.net") by ftp.linux-mips.org with ESMTP
	id S20023790AbXHWM22 (ORCPT <rfc822;linux-wireless@vger.kernel.org>
	+ 3 others); Thu, 23 Aug 2007 13:28:28 +0100
Date: Wed, 22 Aug 2007 23:03:21 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, source@mvista.com,
	dougthompson@xmission.com, bluesmoke-devel@lists.sourceforge.net,
	dtor@mail.ru, linux-input@atrey.karlin.mff.cuni.cz,
	netdev@vger.kernel.org, James.Bottomley@SteelEye.com,
	linux-scsi@vger.kernel.org, gtolstolytkin@ru.mvista.com,
	vitalywool@gmail.com, dsaxena@plexity.net,
	linux-mips@linux-mips.org, mchehab@infradead.org,
	video4linux-list@redhat.com, jbenc@suse.cz,
	flamingice@sourmilk.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 8/9] define global BIT macro
Message-ID: <20070822220321.GA4473@linux-mips.org>
References: <737828602404912540@wsc.cz> <428714662539710215@wsc.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <428714662539710215@wsc.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 18, 2007 at 11:44:12AM +0200, Jiri Slaby wrote:

> define global BIT macro
> 
> move all local BIT defines to the new globally define macro.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Acked-by: Ralf Baechle <ralf@linux-mips.org>

for the MACE ethernet and MIPS bits.

  Ralf

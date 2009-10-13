Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.186]:62043 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbZJMRaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 13:30:17 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: Current status of rt2800usb and staging/rt2870
Date: Tue, 13 Oct 2009 19:27:24 +0200
Cc: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
	linux-wireless@vger.kernel.org,
	"linux-kernel" <linux-kernel@vger.kernel.org>
References: <4AD46380.9020308@pardus.org.tr> <200910131752.52589.IvDoorn@gmail.com>
In-Reply-To: <200910131752.52589.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200910131927.24136.bzolnier@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 13 October 2009 17:52:52 Ivo van Doorn wrote:

> I am going to merge rt2800pci soon as well and after that I'll send a patch

Great, I've been waiting for this for a long time.

> to remove all Ralink drivers from the staging tree.

Till new drivers obtain support for all hardware currently covered by
the unified staging drivers the latter shouldn't be removed as they
serve well their role as a temporary solution allowing real Linux users
to user their real hardware and as a reference material for developers
willing to work on adding the missing bits to new drivers.

Best regards,
Bartlomiej

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hogsmeade.leitwerk.net ([217.28.96.50]:54605 "EHLO
	hogsmeade.leitwerk.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbZJPMNj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 08:13:39 -0400
From: Simon Raffeiner <sturmflut@lieberbiber.de>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [rt2x00-users] [PATCH 2/2] rt2x00: Implement support for rt2800pci
Date: Fri, 16 Oct 2009 14:13:00 +0200
Cc: Ivo van Doorn <ivdoorn@gmail.com>, users@rt2x00.serialmonkey.com,
	linux-wireless@vger.kernel.org
References: <200910152137.58164.IvDoorn@gmail.com> <200910161255.54644.IvDoorn@gmail.com> <ee588a540910160412x27ad2a37i6b80526dfd99f7ea@mail.gmail.com>
In-Reply-To: <ee588a540910160412x27ad2a37i6b80526dfd99f7ea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200910161413.00939.sturmflut@lieberbiber.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag, 16. Oktober 2009 13:12:32 schrieb Xose Vazquez Perez:
> On Fri, Oct 16, 2009 at 12:55, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > Well the main PCI and DEVICE id's should be listed in the PCI_DEVICE
> > table, the SUBSYS ID should only be added in case there can be different
> > drivers based on that ID.
> >
> > As far as the ID 1432:7728, that one was sent by Xose who got the ID from
> > the Windows driver, I don't know if he has mistakenly grabbed the
> > subsystem ID or not... Xose, could you give an update about this?
> 
> It came from ralink linux driver.

Thanks, that explains it.

regards,
Simon Raffeiner

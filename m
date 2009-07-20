Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47344 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbZGTUa7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2009 16:30:59 -0400
Date: Mon, 20 Jul 2009 16:16:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Bastien Nocera <hadess@hadess.net>,
	GeoClue <geoclue@lists.freedesktop.org>,
	linux-wireless <linux-wireless@vger.kernel.org>, desrt@desrt.ca,
	Dan Winship <danw@gnome.org>,
	Tim Gardner <tim.gardner@canonical.com>,
	till.kamppeter@gmail.com
Subject: Re: Using GeoClue to send a Linux wireless regulatory hint
Message-ID: <20090720201616.GF2775@tuxdriver.com>
References: <43e72e890907161810k51e3830bqe3283539f19e2fd2@mail.gmail.com> <1247848427.8139.4386.camel@localhost.localdomain> <43e72e890907170952v20677c7fr50204df952228d53@mail.gmail.com> <43e72e890907170954y20375636s7dad8fd972406310@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <43e72e890907170954y20375636s7dad8fd972406310@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 17, 2009 at 09:54:53AM -0700, Luis R. Rodriguez wrote:
> On Fri, Jul 17, 2009 at 9:52 AM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> 
> > It just reads the country from timezone file, I've pasted the script
> > below inline in case you are curious.
> 
> Oh and here is the script used by Fedora (thanks to John):

This script is invoked by /lib/udev/rules.d/85-regulatory.rules
in Fedora.  This only occurs when a wireless device is added to
the system.  There is currently no awareness of timezone changes --
definitely a short-coming.  We could use some desktop developers to
advise/help with that!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:47263 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762098AbZLPLW7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2009 06:22:59 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
Subject: Re: [PATCH] move eject code from zd1211rw to usb-storage
Date: Wed, 16 Dec 2009 12:23:16 +0100
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
	Josua Dietze <digidietze@draisberghof.de>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com> <20091215180300.GF16426@one-eyed-alien.net> <20091216114932.4bede511@strolchi.home.s3e.de>
In-Reply-To: <20091216114932.4bede511@strolchi.home.s3e.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200912161223.16403.oliver@neukum.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 16. Dezember 2009 11:49:32 schrieb Stefan Seyfried:
> On Tue, 15 Dec 2009 10:03:00 -0800
> Matthew Dharm <mdharm-kernel@one-eyed-alien.net> wrote:
> > The right answer here is neither to move the eject code nor to introduce
> > more of it.  New devices should be supported via userspace.
> 
> Can somebody point me to the "userspace" that is meant here?
> Preferably some code that can be built actually?

Sure:
http://www.draisberghof.de/usb_modeswitch/

	HTH
		Oliver

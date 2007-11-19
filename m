Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:54288 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751750AbXKSWUj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 17:20:39 -0500
Date: Mon, 19 Nov 2007 23:19:35 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: bcm43xx-dev@lists.berlios.de,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <larry.finger@lwfinger.net>, mb@bu3sch.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] remove bcm43xx
Message-ID: <20071119231935.535674ba@morte> (sfid-20071119_222044_191152_6C69D0AB)
In-Reply-To: <200711192300.12183.rjw@sisk.pl>
References: <20071119202121.6ad3fa70@morte>
	<200711192300.12183.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 19 Nov 2007 23:00:11 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Well, are you 100% sure that everyone interested knows that this drivers
> is going out in 2.6.25 and no one will object?

The maintainers know. Having both drivers in 2.6.24 should help find out if
there's anything which should be ironed out with b43/b43legacy, but right
now they are already working a lot better than bcm43xx, and they are more
stable. So I couldn't find a reason why we shouldn't remove bcm43xx in
2.6.25.


-- 
Ciao
Stefano

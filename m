Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0053.hostedemail.com ([216.40.44.53]:40903 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752005AbaLHDzS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2014 22:55:18 -0500
Message-ID: <1418010912.31745.29.camel@perches.com> (sfid-20141208_045547_519662_C4BD1423)
Subject: Re: [PATCH 0/20] fix misspelling of current function in string
From: Joe Perches <joe@perches.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux@rasmusvillemoes.dk, devel@driverdev.osuosl.org,
	linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, linux-mtd@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, netdev@vger.kernel.org,
	linux-usb@vger.kernel.org
Date: Sun, 07 Dec 2014 19:55:12 -0800
In-Reply-To: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-12-07 at 20:20 +0100, Julia Lawall wrote:
> These patches replace what appears to be a reference to the name of the
> current function but is misspelled in some way by either the name of the
> function itself, or by %s and then __func__ in an argument list.

At least a few of these seem to be function tracing
style uses that might as well be deleted instead.


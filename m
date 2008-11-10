Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59188 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbYKJVmP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 16:42:15 -0500
Subject: Re: wi-fi.org certification with libertas + 8686
From: Dan Williams <dcbw@redhat.com>
To: Cliff Brake <cliff.brake@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <f96d234e0811101325u9851ea1l636c46cf38aa2695@mail.gmail.com>
References: <f96d234e0811101325u9851ea1l636c46cf38aa2695@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 10 Nov 2008 16:40:18 -0500
Message-Id: <1226353218.8146.21.camel@localhost.localdomain> (sfid-20081110_224218_854607_E2CC249C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-11-10 at 16:25 -0500, Cliff Brake wrote:
> Hello,
> 
> Has anyone been through wifi certification with the libertas driver
> and the 8686 chipset (or any Linux driver + wpa_supplicant for that
> matter)?  Just trying to get a rough idea how painful this is.

Marvell has probably certified their libertas vendor driver (which isn't
the upstream libertas driver).  With the possible exceptions of Intel
and Atheros (which are both heavily involved in the upstream drivers for
their hardware), none of the upstream kernel drivers have been through
validation or certification that I know of.

Dan



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45474 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab1EEW7n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 18:59:43 -0400
MIME-Version: 1.0
In-Reply-To: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 6 May 2011 08:59:23 +1000
Message-ID: <BANLkTi=epFN2EZBj9n8pac6h7F4RWmyk+Q@mail.gmail.com> (sfid-20110506_010027_213935_FF0DBAEC)
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus driver
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
	=?ISO-8859-1?Q?Michael_B=FCsch?= <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	George Kashperko <george@znau.edu.ua>,
	Arend van Spriel <arend@broadcom.com>,
	linux-arm-kernel@lists.infradead.org,
	Russell King <rmk@arm.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>,
	Andy Botting <andy@andybotting.com>,
	linuxdriverproject <devel@linuxdriverproject.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafa³,

A minor nit:

On Fri, May 6, 2011 at 07:59, Rafa³ Mi³ecki <zajec5@gmail.com> wrote:
> diff --git a/Documentation/ABI/testing/sysfs-bus-bcma b/Documentation/ABI/testing/sysfs-bus-bcma
> new file mode 100644
> index 0000000..ad3cd69
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-bus-bcma
> @@ -0,0 +1,31 @@
> +What:          /sys/bus/bcma/devices/.../class
> +Date:          May 2011
> +KernelVersion: 2.6.40
> +Contact:       Rafa³ Mi³ecki <zajec5@gmail.com>
> +Description:
> +               Each AXI core is identified by few fields, including class it
> +               belongs to. See include/linux/bcma/bcma.h for possible values.

Should this not read BCMA or something similar, not AXI?

Ditto for the rest of the changes to this file.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/

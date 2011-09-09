Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757512Ab1IIB0U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 21:26:20 -0400
Subject: Re: File name for libertas_tf_usb firmware
From: Dan Williams <dcbw@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 08 Sep 2011 20:29:16 -0500
In-Reply-To: <1315530381.23168.56.camel@deadeye>
References: <1315530381.23168.56.camel@deadeye>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1315531757.2327.2.camel@dcbw.foobar.com> (sfid-20110909_032624_063802_81FF9B40)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-09-09 at 02:06 +0100, Ben Hutchings wrote:
> The driver wants to load "lbtf_usb.bin", but we have it in
> linux-firmware.git as "libertas/lbtf_usb.bin".  It seems like we should
> rename it in the repository, as the driver has always used the former
> name.
> 
> If no-one has any objections, I'll do the rename here and push the
> change when I can...

No particular objection.

Dan



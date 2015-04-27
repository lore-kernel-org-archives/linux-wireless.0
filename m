Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:33993 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbbD0HHQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Apr 2015 03:07:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAD3Xx4+vRhswKAbpHnrYQMRNKOppOQzgFOgoJw_1iAfK4baCtQ@mail.gmail.com>
References: <CAD3Xx4+vRhswKAbpHnrYQMRNKOppOQzgFOgoJw_1iAfK4baCtQ@mail.gmail.com>
From: Valentin Rothberg <valentinrothberg@gmail.com>
Date: Mon, 27 Apr 2015 09:06:45 +0200
Message-ID: <CAD3Xx4+eZOrgm_ae9UeUWB+EfUdi5B1jqs1R-CxYzYZ5AvHyfQ@mail.gmail.com> (sfid-20150427_090738_175727_14233570)
Subject: Re: NFC: CONFIG_NFC_DEBUG not defined
To: clement.perrochaud@effinnov.com
Cc: sameo@linux.intel.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, Paul Bolle <pebolle@tiscali.nl>,
	Andreas Ruprecht <rupran@einserver.de>,
	hengelein Stefan <stefan.hengelein@fau.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I took the email from the author field of the commit, which does not
exists anymore.  Now I added Clément's correct email address.

On Mon, Apr 27, 2015 at 9:03 AM, Valentin Rothberg
<valentinrothberg@gmail.com> wrote:
> Hi Clément,
>
> your commit dece45855a8b ("NFC: nxp-nci: Add support for NXP NCI
> chips") adds the Makefile drivers/nfc/nxp-nci/Makefile with the
> following line:
>
> +ccflags-$(CONFIG_NFC_DEBUG) := -DDEBUG
>
> The Kconfig option NFC_DEBUG is not defined so the line turns out to
> be a nop.  There is another reference in drivers/nfc/Makefile.  Is
> there a patch queued somewhere to add the option?
>
> I found this issue with ./scripts/checkkconfigsymbols.py by diffing
> v4.0 and v4.1-rc1.
>
> Kind regards,
>  Valentin

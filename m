Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46330 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749AbYH2Vcm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 17:32:42 -0400
Date: Fri, 29 Aug 2008 18:32:36 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Philip Langdale <philipl@overt.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
	toshiba_acpi@memebeam.org, ivdoorn@gmail.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth
	togglingthrough rfkill (v7)
Message-ID: <20080829213236.GA27281@khazad-dum.debian.net> (sfid-20080829_233245_179414_84000F8B)
References: <20080829141216.f0d69ae4.akpm@linux-foundation.org> <f86c32a17907fdacd870e853761f0382@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f86c32a17907fdacd870e853761f0382@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 29 Aug 2008, Philip Langdale wrote:
> On Fri, 29 Aug 2008 14:12:16 -0700, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > ERROR: "rfkill_force_state" [drivers/acpi/toshiba_acpi.ko] undefined!
> > ERROR: "rfkill_free" [drivers/acpi/toshiba_acpi.ko] undefined!
> > ERROR: "rfkill_register" [drivers/acpi/toshiba_acpi.ko] undefined!
> > ERROR: "rfkill_allocate" [drivers/acpi/toshiba_acpi.ko] undefined!
> > ERROR: "rfkill_unregister" [drivers/acpi/toshiba_acpi.ko] undefined!
> > 
> > I'll stick a `select RFKILL' in there, but it'll probably blow up
> > in other ways.  select usually does.
> 
> Sorry, thanks for catching that. thinkpad_acpi also just does 'select
> RFKILL',

select NET
select RFKILL

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:39475 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751617AbdB0Kg7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 05:36:59 -0500
Date: Mon, 27 Feb 2017 11:36:14 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Rob Herring <robh@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Marcel Holtmann <marcel.holtmann@intel.com>
Subject: Re: [PATCH] NFC: remove TI nfcwilink driver
Message-ID: <20170227103614.GE13501@zurbaran.ger.intel.com> (sfid-20170227_113735_923875_D19A22FD)
References: <20170125222307.3044-1-robh@kernel.org>
 <3B67FD13-A482-4BEF-B619-DD9AF9CC129F@holtmann.org>
 <CAL_JsqL1c9vU0R0m73UXi6wvPscqNT9ZAxX8FxhMmLFGMRAeVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL_JsqL1c9vU0R0m73UXi6wvPscqNT9ZAxX8FxhMmLFGMRAeVQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rob,

On Fri, Feb 24, 2017 at 02:56:48PM -0600, Rob Herring wrote:
> On Wed, Jan 25, 2017 at 11:54 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> > Hi Rob,
> >
> >> It appears that TI WiLink devices including NFC (WL185x/WL189x) never
> >> shipped. The only information I found were announcements in Feb
> >> 2012 about the parts. There's been no activity on this driver besided
> >> common changes since initially added in Jan 2012. There's also no in
> >> users that instantiate the platform device (nor DT bindings).
> >>
> >> This is a first step in removing TI ST (shared transport) driver in
> >> favor of extending the BT hci_ll driver to support WL183x chips.
> >
> > since the firmware files TINfcInit_* also never made it into the linux-firmware tree, I have no idea who is using this driver. I am actually fine with removing it since it would be easy enough to bring back based on hci_ll driver once there is hardware to test this on.
> 
> Ping. Someone going to pick up this patch?
I'll take it, I need to catch up with pending NFC patches this week.

Cheers,
Samuel.

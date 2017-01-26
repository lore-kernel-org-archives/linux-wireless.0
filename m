Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:53803 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751598AbdAZFyW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jan 2017 00:54:22 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Subject: Re: [PATCH] NFC: remove TI nfcwilink driver
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20170125222307.3044-1-robh@kernel.org>
Date: Thu, 26 Jan 2017 06:54:19 +0100
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Ilan Elias <ilane@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Message-Id: <3B67FD13-A482-4BEF-B619-DD9AF9CC129F@holtmann.org> (sfid-20170126_065435_667163_C081B328)
References: <20170125222307.3044-1-robh@kernel.org>
To: Rob Herring <robh@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rob,

> It appears that TI WiLink devices including NFC (WL185x/WL189x) never
> shipped. The only information I found were announcements in Feb
> 2012 about the parts. There's been no activity on this driver besided
> common changes since initially added in Jan 2012. There's also no in
> users that instantiate the platform device (nor DT bindings).
> 
> This is a first step in removing TI ST (shared transport) driver in
> favor of extending the BT hci_ll driver to support WL183x chips.

since the firmware files TINfcInit_* also never made it into the linux-firmware tree, I have no idea who is using this driver. I am actually fine with removing it since it would be easy enough to bring back based on hci_ll driver once there is hardware to test this on.

Regards

Marcel

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60834 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754820AbdA0NHU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 08:07:20 -0500
Date: Fri, 27 Jan 2017 13:53:58 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Hassell, William" <william.hassell@hpe.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlegacy kernel module with SLES 12 SP1
Message-ID: <20170127125358.GA2737@redhat.com> (sfid-20170127_140850_625766_43B9C813)
References: <DF4PR84MB007667FC0FD957BA7226C7EAF1770@DF4PR84MB0076.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <DF4PR84MB007667FC0FD957BA7226C7EAF1770@DF4PR84MB0076.NAMPRD84.PROD.OUTLOOK.COM>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 26, 2017 at 10:49:05PM +0000, Hassell, William wrote:
> Hoping you can help.
> I installed  SUSE SLES 12 SP1 on a Sony Vaio laptop.
> To my surprise, everything is working with the exception of the wireless device.
> It is an Intel WIFI 4965 AGN device and it works fine with Windows 7 OS.
> 
> I have checked that the proper firmware is in /lib/firmware and dmesg shows
> the device is discovered at boot time but no kernel module is loaded.
> 
> I see that there is a module iwlwifi in this distro but no iwlegacy.
> Do I  need this? If so, how do I go about getting this wireless device to work?

You need iwl4965 and iwlegacy modules. IWL 4965 is pretty old device,
hence distribution might not compile/provide those modules.
 
Stanislaw

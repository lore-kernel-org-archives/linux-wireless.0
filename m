Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:44774 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbaKHRmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2014 12:42:36 -0500
Received: by mail-lb0-f181.google.com with SMTP id l4so4035677lbv.40
        for <linux-wireless@vger.kernel.org>; Sat, 08 Nov 2014 09:42:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <733AE580-92D4-486C-888C-9694F6AAB92F@me.com>
References: <733AE580-92D4-486C-888C-9694F6AAB92F@me.com>
Date: Sat, 8 Nov 2014 19:42:34 +0200
Message-ID: <CANUX_P0Ohtjov1gDSQeeoTX1QFoHB46JP5dMRGkHwHKfJJsCRw@mail.gmail.com> (sfid-20141108_184537_853196_D3B2B9B2)
Subject: Re: Intel Wireless 7260 + 5G + AP mode
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: efill@me.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 8, 2014 at 6:33 PM,  <efill@me.com> wrote:
> Dear all,
>
> I’m trying to get the 7260 to act as an AP on the 5G band. Unfortunately it seems to be impossible due to the „no IR“ reg domain restriction done by the Intel firmware internally (this is what I’ve googled so far..).
>
> Could someone explain to me the technical background of this. As far as I understood the regulation if DFS and TPC are used, most of the 5G channels are allowed. Did I miss something? What’s the point of restricting the IR then?

This is not true world wide. With the devices currently available, you
can't have IR in 5GHz.

>
> And finally: Is there a way to get it work? Some other PCI-E chip? ath10k?
>
> All the best,
> Efill--
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

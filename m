Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:58038 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753538Ab1HKL5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 07:57:23 -0400
Received: by mail-bw0-f44.google.com with SMTP id r4so873343bka.3
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 04:57:21 -0700 (PDT)
Subject: Re: [PATCH 00/40] wl12xx: move to wl12xx-fw-3
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Aug 2011 14:57:18 +0300
Message-ID: <1313063838.2407.852.camel@cumari> (sfid-20110811_135726_782257_FCBCA4CE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> The new wl12xx fw (ver 7.3.0.0.75) had some major api changes.
> The main change was the addition of multi-role concept, which
> will later allow using multiple vifs concurrently.
> 
> Consequently, this design change caused api changes for most
> of the api commands, as a new role_id had to be added.
> 
> This patchset migrates the fw to use the new fw api (a new
> fw filename is used, as there is no backward compatability
> with older firmwares).

Okay, I'm done with my review! Lots of small nitpicking, but this in
general looks very good! Thanks a lot for the good work, guys!


-- 
Cheers,
Luca.


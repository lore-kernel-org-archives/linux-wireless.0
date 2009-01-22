Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13184 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbZAVPRy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 10:17:54 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 07:17:54 -0800
Date: Thu, 22 Jan 2009 07:17:20 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Delphi Real Estate <Info@delphi-real-estate.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Kernel Compile Fail with 2.6.26 Drivers
Message-ID: <20090122151720.GB9245@tesla> (sfid-20090122_161759_559279_D5AC1753)
References: <200901200942.57618.Info@delphi-real-estate.com> <200901220558.05104.Info@delphi-real-estate.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <200901220558.05104.Info@delphi-real-estate.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 22, 2009 at 05:58:04AM -0800, Delphi Real Estate wrote:
> 
> It seems that either no one has 'n' working at 5GHz

As for Atheros stuff you can use ath9k or otus for 11n 5 GHz. I believe
iwlagn should work but aggregation is not enabled as it still needs
to be fixed.

  Luis

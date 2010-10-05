Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:30919 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab0JEMJH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 08:09:07 -0400
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o95C8r4H010675
	for <linux-wireless@vger.kernel.org>; Tue, 5 Oct 2010 15:09:05 +0300
Subject: Re: [PATCHv2] wl1271: Add extended radio parameter initialization
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "Oikarinen Juuso (Nokia-MS/Tampere)" <juuso.oikarinen@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286279274.15401.21.camel@chilepepper>
References: <1286277116-22486-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1286279274.15401.21.camel@chilepepper>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 15:08:57 +0300
Message-ID: <1286280537.15401.30.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-05 at 13:47 +0200, ext Luciano Coelho wrote:
> On Tue, 2010-10-05 at 13:11 +0200, juuso.oikarinen@nokia.com wrote:
> > From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > 
> > Currently a command to initialize extended radio parameter tables in the
> > hardware is missing.
> > 
> > Add the initialization
> > 
> > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > ---
> > v2: change the name of the length macro for the TX power compensation table
> 
> Thanks for fixing it, it looks clearer now.
> 
> Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
> 

Applied to wl12xx/master.


-- 
Cheers,
Luca.


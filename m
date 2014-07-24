Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207AbaGXQAX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 12:00:23 -0400
Message-ID: <1406217620.5015.2.camel@dcbw.local> (sfid-20140724_180030_130896_D3150D34)
Subject: Re: How to get RSSI periodically
From: Dan Williams <dcbw@redhat.com>
To: Jean-Marie Lemetayer <jeanmarie.lemetayer@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 24 Jul 2014 11:00:20 -0500
In-Reply-To: <CAAdc0hyDepy7zn+1TQsjcZpkSkQrwFhbkPBJoH0vYKqbqkktAg@mail.gmail.com>
References: <CAAdc0hyDepy7zn+1TQsjcZpkSkQrwFhbkPBJoH0vYKqbqkktAg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-07-24 at 17:25 +0200, Jean-Marie Lemetayer wrote:
> Hi,
> 
> I am looking for a way to get the RSSI of the SELECTED network with
> the wpa_supplicant (2.1). To update periodically the status connection
> icon of my app.
> 
> I known that I can get it with the command: 'bss <bssid>' but it seems
> that this information is updated only when perform a scan.
> 
> Have I miss something simpler than doing a background scan on the freq
> of the SELECTED network ?

Try the SIGNAL_POLL control interface command (called "signal_poll" for
wpa_cli).

Dan


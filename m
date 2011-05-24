Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab1EXHJv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 03:09:51 -0400
Date: Tue, 24 May 2011 09:09:42 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [iwl4965] Microcode SW error detected
Message-ID: <20110524070941.GA2189@redhat.com> (sfid-20110524_090955_552679_A62C0211)
References: <1306151106.2066.60.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1306151106.2066.60.camel@x61.thuisdomein>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 23, 2011 at 01:45:06PM +0200, Paul Bolle wrote:
> 0) Since I started running (release candidates of) kernel v2.6.39 errors
> like these show up in my log, every now and then:
>
> iwl4965 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[snip]
> 1) Is there anything I'm supposed to do to (help) make these errors go
> away?

Does it also happen on 2.6.39-rc1 ? What is your configuration (mode,
encryption, do you use wpa_supplicant or NetworkManager, which version,
etc ...)? I will try to reproduce locally. If I'll be not able to reproduce,
I'll ask you for debug logs on broken, and working (i.e. 2.6.38) version
for compare. 

Thanks
Stanislaw

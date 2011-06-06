Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:50965 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab1FFI6t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 04:58:49 -0400
Subject: Re: [iwl4965] Microcode SW error detected
From: Paul Bolle <pebolle@tiscali.nl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20110531133736.GA2935@redhat.com>
References: <1306151106.2066.60.camel@x61.thuisdomein>
	 <20110524070941.GA2189@redhat.com>
	 <1306255853.12267.14.camel@x61.thuisdomein>
	 <20110525131130.GA3260@redhat.com>
	 <1306330313.2119.4.camel@x61.thuisdomein>
	 <20110531133736.GA2935@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 10:58:42 +0200
Message-ID: <1307350722.10094.29.camel@x61.thuisdomein> (sfid-20110606_105853_414174_3721D17D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-05-31 at 15:37 +0200, Stanislaw Gruszka wrote:
> My all attempts of reproduce the problem was unsuccessful. Please
> send me (off list since this could be quite big) dmesg output from 
> loading module to first microcode error, when using verbose debug eg:
> 
> $ modprobe -r iwl4965
> $ modprobe iwl4965 debug=0x47ffffff  
> 
> Note: driver have to be compiled with CONFIG_IWLWIFI_LEGACY_DEBUG.
> Also dmesg circular buffer can be too small to contain all requested
> messages. In such case, you will have to configure syslog like described
> here:
> https://bugzilla.kernel.org/show_bug.cgi?id=35932#c2

0) I have not yet done that, but I do hope to do it shortly.

1) This Microcode SW error pops up only every now and then, so I'm
afraid I might find myself logging debug messages for quite some time.
What is the average volume of those messages? If it's no more than, say,
10 MB/min I can still run in verbose debug mode for hours on end without
worrying about running out of disk space.  


Paul Bolle


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:55557 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbZKWTgj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 14:36:39 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NCeiJ-0005fn-2i
	for linux-wireless@vger.kernel.org; Mon, 23 Nov 2009 20:36:43 +0100
Received: from lister.visitors.farnz.org.uk ([81.187.250.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 20:36:43 +0100
Received: from simon by lister.visitors.farnz.org.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 20:36:43 +0100
To: linux-wireless@vger.kernel.org
From: Simon Farnsworth <simon@farnz.org.uk>
Subject: Re: HTC Hero cannot get an address from an ath5k AP
Date: Mon, 23 Nov 2009 19:36:13 +0000
Message-ID: <heeo7d$pg4$1@ger.gmane.org>
References: <hebaok$2ip$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 22 November 2009 12:28, Simon Farnsworth wrote:

> My hostapd configuration file is attached; I've checked that I've used the
> correct WEP key. I can provide any more information that's needed. My
> controller appears in lspci as:
> 
Just realised that I forgot the most important information:

My kernel is wireless-testing git master as of commit 
fe1bafb0a2e95c9379df62e6ccc80713096c283c

My hostapd is git master as of commit 
224f7bda793010087833899a5b203ac80a05b208

-- 
Simon


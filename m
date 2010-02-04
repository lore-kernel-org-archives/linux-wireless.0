Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:10196 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab0BDJxj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 04:53:39 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: cfg80211 support
Date: Thu, 4 Feb 2010 10:52:00 +0100
Cc: Samuel Ortiz <sameo@linux.intel.com>
References: <20100202000934.GA19847@sortiz.org>
In-Reply-To: <20100202000934.GA19847@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201002041052.00858.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>     + Slightly changed the scanning state machine: The scan
>       worker is scheduled from the scan response handler, and
>       we're checking for scan_channel to know if a scan is
>       currently running. 

Can you tell my why you change the scanning state machine?  What 
was broken with it, or why is it now better?


Also, previously priv->scan_req was the marker that a scan was 
going on. What did it "buy" to you to change this to 
priv->scan_channel?

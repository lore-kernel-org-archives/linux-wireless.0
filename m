Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:55583 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036AbZCQLCp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 07:02:45 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFT/RFC 2/2] b43legacy: Beacon IRQ changes
Date: Tue, 17 Mar 2009 12:01:36 +0100
Cc: david@identd.dyndns.org, linux-wireless@vger.kernel.org
References: <49bf248f.XzFFJoNYeRJgRKi6%Larry.Finger@lwfinger.net>
In-Reply-To: <49bf248f.XzFFJoNYeRJgRKi6%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903171201.36211.mb@bu3sch.de> (sfid-20090317_120248_077151_00B031CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 17 March 2009 05:18:23 Larry Finger wrote:
> This patch ports commit c97a4ccc1fad35d3 "b43: Fix beacon BH update" to
> b43legacy. It fixes beacon updating in the bottomhalf. In case the device
> is busy, we will defer to later in the IRQ handler.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Both patches look fine. Please add my ack to both of them and forward them
to John after some testing.

-- 
Greetings, Michael.
